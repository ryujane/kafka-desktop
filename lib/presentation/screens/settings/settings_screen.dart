import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/l10n/app_localizations.dart';
import 'package:kafkax/presentation/providers/settings_providers.dart';

/// Settings screen with connection management and theme selection.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final currentMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: ListView(
        children: [
          // Connections section.
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: Text(s.settingsAddConnection),
            onTap: () {
              // TODO: Navigate to add connection dialog/screen.
            },
          ),
          const Divider(),
          // Theme section.
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
          // About section.
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
}
