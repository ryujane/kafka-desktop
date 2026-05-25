import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/core/theme/theme_extension.dart';
import 'package:kafkax/data/models/log_entry.dart';
import 'package:kafkax/l10n/app_localizations.dart';
import 'package:kafkax/presentation/providers/log_providers.dart';

/// Collapsible log viewer panel displayed above the status bar.
class LogPanel extends ConsumerWidget {
  const LogPanel({required this.expanded, required this.onToggle, super.key});

  /// Whether the log panel is currently expanded.
  final bool expanded;

  /// Callback to toggle the panel visibility.
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!expanded) return const SizedBox.shrink();

    final colors = Theme.of(context).extension<KafkaXColors>()!;
    final theme = Theme.of(context);
    final logsAsync = ref.watch(appLogProvider);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          _LogPanelHeader(onClear: () {}, onClose: onToggle),
          Expanded(
            child: logsAsync.when(
              data: (logs) => _LogEntryList(logs: logs, colors: colors),
              loading: () => const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (e, _) => Center(child: Text('Error loading logs: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header bar for the log panel with clear and close buttons.
class _LogPanelHeader extends StatelessWidget {
  const _LogPanelHeader({required this.onClear, required this.onClose});

  final VoidCallback onClear;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            s.logPanelTitle,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 14),
            onPressed: onClear,
            tooltip: 'Clear logs',
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            padding: EdgeInsets.zero,
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 14),
            onPressed: onClose,
            tooltip: s.close,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

/// Scrollable list of log entries.
class _LogEntryList extends StatelessWidget {
  const _LogEntryList({required this.logs, required this.colors});

  final List<LogEntry> logs;
  final KafkaXColors colors;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Center(child: Text(S.of(context)!.noData));
    }

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final entry = logs[logs.length - 1 - index];
        return _LogEntryRow(entry: entry, colors: colors);
      },
    );
  }
}

/// A single row representing one log entry.
class _LogEntryRow extends StatelessWidget {
  const _LogEntryRow({required this.entry, required this.colors});

  final LogEntry entry;
  final KafkaXColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              _formatTime(entry.timestamp),
              style: theme.textTheme.labelSmall,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              entry.level.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: _levelColor(entry.level),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(entry.message, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  Color? _levelColor(LogLevel level) => switch (level) {
    LogLevel.debug => colors.logInfo,
    LogLevel.info => colors.logInfo,
    LogLevel.warn => colors.logWarn,
    LogLevel.error => colors.logError,
  };

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}:'
      '${dt.second.toString().padLeft(2, '0')}';
}
