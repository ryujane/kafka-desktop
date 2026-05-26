import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_extension.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/settings_providers.dart';
import 'presentation/widgets/app_shell.dart';

class KafkaXApp extends ConsumerWidget {
  const KafkaXApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp(
      title: 'KafkaX',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      locale: locale,
      theme: AppTheme.light().copyWith(
        extensions: const [
          KafkaXColors(
            sidebarBackground: Color(0xFFF5F5F5),
            statusBarBackground: Color(0xFFE0E0E0),
            connectionOnline: Colors.green,
            connectionOffline: Colors.grey,
            logInfo: Colors.blue,
            logWarn: Colors.orange,
            logError: Colors.red,
          ),
        ],
      ),
      darkTheme: AppTheme.dark().copyWith(
        extensions: const [
          KafkaXColors(
            sidebarBackground: Color(0xFF1E1E1E),
            statusBarBackground: Color(0xFF2D2D2D),
            connectionOnline: Colors.green,
            connectionOffline: Colors.grey,
            logInfo: Colors.blueAccent,
            logWarn: Colors.orangeAccent,
            logError: Colors.redAccent,
          ),
        ],
      ),
      themeMode: themeMode,
      home: const AppShell(),
    );
  }
}
