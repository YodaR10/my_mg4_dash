import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app/app.dart';
import 'src/app/providers/app_settings_provider.dart';
import 'src/core/logging/app_logger.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await LiquidGlassShaders.ensureLoaded();

    // Performance tuning for lower-end devices:
    // - shader blur in batches keeps a single shared read
    // - shape cache is on by default (Impeller on Android/iOS)
    LiquidGlassConfiguration.batchBlurMethod = LiquidGlassBlurMethod.shader;

    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    final settings = container.read(appSettingsProvider);
    await AppLogger.instance.init(enabled: settings.loggingEnabled);
    await applySystemUi(settings);

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
  }, (error, stack) {
    AppLogger.instance.recordError(error, stack, level: 'ZONED');
  });
}
