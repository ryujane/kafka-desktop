import 'package:shared_preferences/shared_preferences.dart';

/// Read/write access to application-wide settings persisted locally.
class SettingsRepository {
  static const _themeKey = 'theme_mode';
  static const _maxMessagesKey = 'max_messages_per_fetch';
  static const _defaultTimeoutKey = 'default_timeout';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  // -- Theme --

  String get themeMode => _prefs.getString(_themeKey) ?? 'system';
  Future<void> setThemeMode(String mode) => _prefs.setString(_themeKey, mode);

  // -- Messages --

  int get maxMessagesPerFetch => _prefs.getInt(_maxMessagesKey) ?? 500;
  Future<void> setMaxMessagesPerFetch(int count) =>
      _prefs.setInt(_maxMessagesKey, count);

  // -- Timeout --

  int get defaultTimeout => _prefs.getInt(_defaultTimeoutKey) ?? 10000;
  Future<void> setDefaultTimeout(int ms) =>
      _prefs.setInt(_defaultTimeoutKey, ms);
}
