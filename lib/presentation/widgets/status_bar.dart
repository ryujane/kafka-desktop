import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/core/theme/theme_extension.dart';
import 'package:kafkax/presentation/providers/connection_providers.dart';

/// Bottom status bar displaying active connection information.
class StatusBar extends ConsumerWidget {
  const StatusBar({
    required this.onLogToggle,
    required this.logPanelExpanded,
    super.key,
  });

  /// Callback to toggle the log panel visibility.
  final VoidCallback onLogToggle;

  /// Whether the log panel is currently expanded.
  final bool logPanelExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // Connection status indicator.
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
                : 'No active connection',
            style: theme.textTheme.labelSmall,
          ),
          const Spacer(),
          // Log toggle button.
          Tooltip(
            message: logPanelExpanded ? 'Hide Logs' : 'Show Logs',
            child: InkWell(
              onTap: onLogToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.terminal,
                      size: 14,
                      color: theme.textTheme.labelSmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text('Logs', style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
