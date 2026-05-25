import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_extension.dart';

class KafkaXApp extends ConsumerWidget {
  const KafkaXApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'KafkaX',
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
      home: const Scaffold(body: Center(child: Text('KafkaX'))),
    );
  }
}
