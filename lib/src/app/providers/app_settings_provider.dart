import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../features/settings/data/app_settings_repository.dart';
import '../../features/settings/domain/app_settings.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository(ref.watch(sharedPreferencesProvider));
});

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.watch(appSettingsRepositoryProvider).load();
  }

  Future<void> update(AppSettings value) async {
    if (value == state) return;
    final previous = state;
    state = value;
    await applySystemUi(value);
    if (previous.loggingEnabled != value.loggingEnabled) {
      await AppLogger.instance.setEnabled(value.loggingEnabled);
    }
    await ref.read(appSettingsRepositoryProvider).save(value);
  }
}

Future<void> applySystemUi(AppSettings settings) async {
  final List<SystemUiOverlay> overlays = <SystemUiOverlay>[
    if (!settings.hideTopSystemBar) SystemUiOverlay.top,
    if (!settings.hideBottomSystemBar) SystemUiOverlay.bottom,
  ];
  if (overlays.length == 2) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  } else if (overlays.isEmpty) {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: const <SystemUiOverlay>[],
    );
  } else {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: overlays,
    );
  }
}
