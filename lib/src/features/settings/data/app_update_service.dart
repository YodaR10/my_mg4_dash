import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/app_settings.dart';

class AppReleaseInfo {
  const AppReleaseInfo({
    required this.tag,
    required this.name,
    required this.versionName,
    required this.isPrerelease,
    required this.apkUrl,
    required this.apkName,
    required this.body,
    required this.htmlUrl,
  });

  final String tag;
  final String name;
  final String versionName; // es. 1.1.0-beta.1
  final bool isPrerelease;
  final String apkUrl;
  final String apkName;
  final String body;
  final String htmlUrl;
}

class UpdateCheckResult {
  const UpdateCheckResult._({
    required this.currentVersion,
    required this.currentBuild,
    this.latest,
    this.error,
  });

  factory UpdateCheckResult.success({
    required String currentVersion,
    required String currentBuild,
    AppReleaseInfo? latest,
  }) => UpdateCheckResult._(
    currentVersion: currentVersion,
    currentBuild: currentBuild,
    latest: latest,
  );

  factory UpdateCheckResult.failure({
    required String currentVersion,
    required String currentBuild,
    required String error,
  }) => UpdateCheckResult._(
    currentVersion: currentVersion,
    currentBuild: currentBuild,
    error: error,
  );

  final String currentVersion;
  final String currentBuild;
  final AppReleaseInfo? latest;
  final String? error;

  bool get hasUpdate {
    final l = latest;
    if (l == null) return false;
    return _isNewer(l.versionName, currentVersion);
  }
}

bool _isNewer(String remote, String current) {
  // Confronto semplice: normalizza rimuovendo prefisso 'v' e confronta
  // versionName+build non sempre disponibile da GitHub; qui usiamo versionName.
  // Se uguali come stringa, non è più nuovo. Se diverse, prova confronto semver base.
  String norm(String v) =>
      v.trim().replaceFirst(RegExp(r'^v', caseSensitive: false), '');
  final r = norm(remote);
  final c = norm(current);
  if (r == c) return false;
  final rp = _parseParts(r);
  final cp = _parseParts(c);
  if (rp == null || cp == null) return r != c;
  for (var i = 0; i < 3; i++) {
    final rv = i < rp.core.length ? rp.core[i] : 0;
    final cv = i < cp.core.length ? cp.core[i] : 0;
    if (rv != cv) return rv > cv;
  }
  // core uguale: una versione con pre-release (beta) è considerata precedente alla stabile
  if (rp.pre != null && cp.pre == null) return false;
  if (rp.pre == null && cp.pre != null) return true;
  if (rp.pre != null && cp.pre != null) return rp.pre!.compareTo(cp.pre!) > 0;
  return false;
}

class _VerParts {
  _VerParts(this.core, this.pre);
  final List<int> core;
  final String? pre;
}

_VerParts? _parseParts(String v) {
  final mainAndPre = v.split('-');
  final coreStr = mainAndPre.first.split('+').first;
  final pre = mainAndPre.length > 1
      ? mainAndPre.sublist(1).join('-').split('+').first
      : null;
  final nums = <int>[];
  for (final p in coreStr.split('.')) {
    final n = int.tryParse(p);
    if (n == null) return null;
    nums.add(n);
  }
  return _VerParts(nums, pre);
}

class AppUpdateService {
  AppUpdateService({http.Client? client, String? repo})
    : _client = client ?? http.Client(),
      _repo = repo ?? 'YodaR10/my_mg4_dash';

  final http.Client _client;
  final String _repo;

  static const _headers = {
    'Accept': 'application/vnd.github+json',
    'User-Agent': 'my_mg4_dash-updater',
  };

  Future<UpdateCheckResult> check(AppUpdateChannel channel) async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version; // versionName
    final currentBuild = info.buildNumber;
    try {
      final release = channel == AppUpdateChannel.stable
          ? await _fetchLatestStable()
          : await _fetchLatestBeta();
      if (release == null) {
        return UpdateCheckResult.success(
          currentVersion: currentVersion,
          currentBuild: currentBuild,
        );
      }
      return UpdateCheckResult.success(
        currentVersion: currentVersion,
        currentBuild: currentBuild,
        latest: release,
      );
    } catch (e) {
      return UpdateCheckResult.failure(
        currentVersion: currentVersion,
        currentBuild: currentBuild,
        error: e.toString(),
      );
    }
  }

  Future<AppReleaseInfo?> _fetchLatestStable() async {
    final uri = Uri.https('api.github.com', '/repos/$_repo/releases/latest');
    final res = await _client.get(uri, headers: _headers);
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) {
      throw Exception('GitHub API ${res.statusCode}: ${res.body}');
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return _toRelease(map);
  }

  Future<AppReleaseInfo?> _fetchLatestBeta() async {
    final uri = Uri.https('api.github.com', '/repos/$_repo/releases');
    final res = await _client.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('GitHub API ${res.statusCode}: ${res.body}');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    for (final item in list) {
      final map = item as Map<String, dynamic>;
      if (map['draft'] == true) continue;
      if (map['prerelease'] == true) {
        return _toRelease(map);
      }
    }
    return null;
  }

  AppReleaseInfo? _toRelease(Map<String, dynamic> map) {
    final assets = (map['assets'] as List<dynamic>? ?? const []);
    Map<String, dynamic>? apk;
    for (final a in assets) {
      final m = a as Map<String, dynamic>;
      final name = (m['name'] as String? ?? '').toLowerCase();
      if (name.endsWith('.apk')) {
        apk = m;
        break;
      }
    }
    if (apk == null) return null;
    final tag = map['tag_name'] as String? ?? '';
    final versionName = tag.replaceFirst(
      RegExp(r'^v', caseSensitive: false),
      '',
    );
    return AppReleaseInfo(
      tag: tag,
      name: map['name'] as String? ?? tag,
      versionName: versionName,
      isPrerelease: map['prerelease'] == true,
      apkUrl: apk['browser_download_url'] as String? ?? '',
      apkName: apk['name'] as String? ?? 'update.apk',
      body: map['body'] as String? ?? '',
      htmlUrl: map['html_url'] as String? ?? '',
    );
  }

  Future<File> downloadApk(
    AppReleaseInfo release, {
    void Function(int received, int total)? onProgress,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${release.apkName}');
    final req = http.Request('GET', Uri.parse(release.apkUrl));
    req.headers.addAll(_headers);
    final res = await _client.send(req);
    if (res.statusCode != 200) {
      throw Exception('Download fallito: HTTP ${res.statusCode}');
    }
    final total = res.contentLength ?? 0;
    var received = 0;
    final sink = file.openWrite();
    await for (final chunk in res.stream) {
      sink.add(chunk);
      received += chunk.length;
      onProgress?.call(received, total);
    }
    await sink.close();
    return file;
  }

  Future<void> installApk(File file) async {
    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }
  }
}
