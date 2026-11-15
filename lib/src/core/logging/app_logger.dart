import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Lightweight file logger for on-device diagnostics (no ADB/PC required).
///
/// Captures Flutter/framework errors, uncaught zone errors and [debugPrint]
/// output while enabled, and can export the log file to removable storage
/// (e.g. a USB stick) for retrieval.
class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  static const String _fileName = 'my_mg4_dash.log';

  bool _enabled = false;
  bool _installed = false;
  IOSink? _sink;
  File? _file;
  final List<String> _buffer = <String>[];
  static const int _maxBufferedLines = 2000;

  DebugPrintCallback? _previousDebugPrint;
  FlutterExceptionHandler? _previousFlutterOnError;
  bool Function(Object, StackTrace)? _previousPlatformOnError;

  bool get isEnabled => _enabled;
  String? get logFilePath => _file?.path;

  Future<void> init({required bool enabled}) async {
    _file ??= File('${Directory.systemTemp.path}/$_fileName');
    _installHandlers();
    await setEnabled(enabled);
  }

  void _installHandlers() {
    if (_installed) return;
    _installed = true;

    _previousDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (_enabled && message != null) {
        _write('DEBUG', message);
      }
      final prev = _previousDebugPrint;
      if (prev != null) {
        prev(message, wrapWidth: wrapWidth);
      }
    };

    _previousFlutterOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (_enabled) {
        _write('FLUTTER', details.exceptionAsString());
        final stack = details.stack?.toString();
        if (stack != null && stack.isNotEmpty) {
          _write('STACK', stack);
        }
      }
      final prev = _previousFlutterOnError;
      if (prev != null) {
        prev(details);
      } else {
        FlutterError.presentError(details);
      }
    };

    _previousPlatformOnError = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      if (_enabled) {
        _write('PLATFORM', error.toString());
        _write('STACK', stack.toString());
      }
      final prev = _previousPlatformOnError;
      if (prev != null) {
        return prev(error, stack);
      }
      return false;
    };
  }

  Future<void> setEnabled(bool enabled) async {
    if (_enabled == enabled && (_sink != null) == enabled) return;
    _enabled = enabled;
    if (enabled) {
      await _openSink();
      log('Logging abilitato');
    } else {
      log('Logging disabilitato');
      await _closeSink();
    }
  }

  Future<void> _openSink() async {
    await _closeSink();
    try {
      final file = _file ?? File('${Directory.systemTemp.path}/$_fileName');
      _file = file;
      _sink = file.openWrite(mode: FileMode.append);
      _sink!.writeln('---- session ${DateTime.now().toIso8601String()} ----');
    } catch (_) {
      _sink = null;
    }
  }

  Future<void> _closeSink() async {
    try {
      await _sink?.flush();
      await _sink?.close();
    } catch (_) {
      // ignore
    }
    _sink = null;
  }

  void log(String message, {String level = 'INFO'}) {
    if (!_enabled) return;
    _write(level, message);
  }

  void recordError(Object error, StackTrace stack, {String level = 'ERROR'}) {
    if (!_enabled) return;
    _write(level, error.toString());
    _write('STACK', stack.toString());
  }

  void _write(String level, String message) {
    final line = '[${DateTime.now().toIso8601String()}][$level] $message';
    _buffer.add(line);
    if (_buffer.length > _maxBufferedLines) {
      _buffer.removeRange(0, _buffer.length - _maxBufferedLines);
    }
    try {
      _sink?.writeln(line);
    } catch (_) {
      // ignore write failures
    }
  }

  Future<String> readLog() async {
    try {
      final file = _file;
      if (file != null && await file.exists()) {
        return await file.readAsString();
      }
    } catch (_) {
      // ignore
    }
    return _buffer.join('\n');
  }

  Future<void> clear() async {
    _buffer.clear();
    try {
      await _closeSink();
      final file = _file;
      if (file != null && await file.exists()) {
        await file.writeAsString('');
      }
    } catch (_) {
      // ignore
    } finally {
      if (_enabled) {
        await _openSink();
      }
    }
  }

  /// Copies the log to a removable/USB volume if found.
  /// Returns a user-facing result message.
  Future<String> exportToUsb() async {
    try {
      await _sink?.flush();
      final source = _file;
      if (source == null || !await source.exists()) {
        return 'Nessun file di log disponibile.';
      }
      final bytes = await source.readAsBytes();
      if (bytes.isEmpty) {
        return 'Il log è vuoto.';
      }

      final dirs = await _findRemovableDirs();
      final stamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .replaceAll('.', '-');
      final exportName = 'my_mg4_dash_$stamp.log';

      for (final dir in dirs) {
        try {
          final targetDir = Directory('${dir.path}/my_mg4_dash_logs');
          if (!await targetDir.exists()) {
            await targetDir.create(recursive: true);
          }
          final target = File('${targetDir.path}/$exportName');
          await target.writeAsBytes(bytes, flush: true);
          return 'Log esportato su: ${target.path}';
        } catch (_) {
          // try next candidate
        }
      }

      // Fallback: copy next to internal log and report path.
      final fallback = File('${source.parent.path}/$exportName');
      await fallback.writeAsBytes(bytes, flush: true);
      return 'Nessuna chiavetta USB scrivibile trovata. Log copiato in: ${fallback.path}';
    } catch (e) {
      return 'Errore durante l\'esportazione: $e';
    }
  }

  Future<List<Directory>> _findRemovableDirs() async {
    final List<Directory> result = <Directory>[];
    final Set<String> seen = <String>{};

    Future<void> addCandidates(String rootPath) async {
      final root = Directory(rootPath);
      if (!await root.exists()) return;
      try {
        await for (final entity in root.list(followLinks: false)) {
          if (entity is! Directory) continue;
          final name = entity.uri.pathSegments.length >= 2
              ? entity.uri.pathSegments[entity.uri.pathSegments.length - 2]
              : entity.path.split('/').last;
          if (name == 'emulated' || name == 'self') continue;
          final path = entity.path;
          if (seen.add(path)) result.add(Directory(path));
        }
      } catch (_) {
        // ignore permission/listing issues
      }
    }

    await addCandidates('/storage');
    await addCandidates('/mnt/media_rw');

    final mntUser = Directory('/mnt/user/0');
    if (await mntUser.exists()) {
      await addCandidates(mntUser.path);
    }
    return result;
  }
}
