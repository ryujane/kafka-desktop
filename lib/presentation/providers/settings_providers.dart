import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/data/repositories/settings_repository.dart';
import 'connection_providers.dart';

part 'settings_providers.g.dart';

/// Provides the [SettingsRepository] instance.
@Riverpod(keepAlive: true)
Future<SettingsRepository> settingsRepository(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return SettingsRepository(prefs);
}

/// Manages the application theme mode preference.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    final asyncRepo = ref.watch(settingsRepositoryProvider);
    if (!asyncRepo.hasValue) return ThemeMode.system;
    return _fromString(asyncRepo.requireValue.themeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repo = await ref.read(settingsRepositoryProvider.future);
    await repo.setThemeMode(_toString(mode));
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

/// Manages the application locale preference.
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale? build() {
    final asyncRepo = ref.watch(settingsRepositoryProvider);
    if (!asyncRepo.hasValue) return null;
    return _fromString(asyncRepo.requireValue.locale);
  }

  Future<void> setLocale(Locale? locale) async {
    final repo = await ref.read(settingsRepositoryProvider.future);
    await repo.setLocale(_toString(locale));
    state = locale;
  }

  static Locale? _fromString(String value) => switch (value) {
    'en' => const Locale('en'),
    'zh' => const Locale('zh'),
    _ => null, // system default
  };

  static String _toString(Locale? locale) => locale?.languageCode ?? 'system';
}
