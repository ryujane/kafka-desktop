import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/data/repositories/settings_repository.dart';
import 'connection_providers.dart';

part 'settings_providers.g.dart';

/// Provides the [SettingsRepository] instance.
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return SettingsRepository(prefs);
}

/// Manages the application theme mode preference.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return _fromString(repo.themeMode);
  }

  /// Updates the theme mode and persists the preference.
  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(settingsRepositoryProvider).setThemeMode(_toString(mode));
    state = mode;
  }

  static ThemeMode _fromString(String value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  static String _toString(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}
