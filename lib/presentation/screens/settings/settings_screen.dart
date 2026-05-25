import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/presentation/providers/settings_providers.dart';

/// Settings screen with connection management and theme selection.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Connections section.
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Connection'),
            subtitle: const Text('Configure a new Kafka cluster connection'),
            onTap: () {
              // TODO: Navigate to add connection dialog/screen.
            },
          ),
          const Divider(),
          // Theme section.
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(_themeLabel(currentMode)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
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
            title: const Text('About KafkaX'),
            subtitle: const Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'Follow system setting',
    ThemeMode.light => 'Light mode',
    ThemeMode.dark => 'Dark mode',
  };
}
