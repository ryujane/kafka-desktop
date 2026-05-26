import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/core/theme/theme_extension.dart';
import 'package:kafkax/l10n/app_localizations.dart';
import 'package:kafkax/presentation/providers/connection_providers.dart';

/// Bottom status bar displaying active connection information.
class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final colors = Theme.of(context).extension<KafkaXColors>()!;
    final theme = Theme.of(context);
    final activeAsync = ref.watch(activeConnectionProvider);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        colors.statusBarBackground ??
        (isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE0E0E0));

    return Container(
      height: 28,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: activeAsync.value != null
                ? colors.connectionOnline ?? Colors.green
                : colors.connectionOffline ?? Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            activeAsync.value != null
                ? '${activeAsync.value!.name} (${activeAsync.value!.brokers})'
                : s.statusNoConnection,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
