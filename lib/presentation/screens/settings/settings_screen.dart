import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/l10n/app_localizations.dart';
import 'package:kafkax/presentation/providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final currentMode = ref.watch(appThemeModeProvider);
    final currentLocale = ref.watch(appLocaleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: Text(s.settingsAddConnection),
            onTap: () {
              // TODO: Navigate to add connection dialog/screen.
            },
          ),
          const Divider(),

          // Theme
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(s.settingsTheme),
            subtitle: Text(_themeLabel(s, currentMode)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(s.settingsThemeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(s.settingsThemeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(s.settingsThemeDark),
                ),
              ],
              selected: {currentMode},
              onSelectionChanged: (modes) {
                ref
                    .read(appThemeModeProvider.notifier)
                    .setThemeMode(modes.first);
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),

          // Language
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(s.settingsLanguage),
            subtitle: Text(_localeLabel(s, currentLocale)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<Locale?>(
              segments: [
                ButtonSegment(value: null, label: Text(s.settingsLangSystem)),
                ButtonSegment(
                  value: const Locale('en'),
                  label: Text(s.settingsLangEnglish),
                ),
                ButtonSegment(
                  value: const Locale('zh'),
                  label: Text(s.settingsLangChinese),
                ),
              ],
              selected: {currentLocale},
              onSelectionChanged: (locales) {
                ref.read(appLocaleProvider.notifier).setLocale(locales.first);
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(s.appName),
            subtitle: const Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }

  String _themeLabel(S s, ThemeMode mode) => switch (mode) {
    ThemeMode.system => s.settingsThemeSystem,
    ThemeMode.light => s.settingsThemeLight,
    ThemeMode.dark => s.settingsThemeDark,
  };

  String _localeLabel(S s, Locale? locale) => switch (locale?.languageCode) {
    'en' => s.settingsLangEnglish,
    'zh' => s.settingsLangChinese,
    _ => s.settingsLangSystem,
  };
}
