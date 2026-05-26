import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/core/theme/theme_extension.dart';
import 'package:kafkax/data/models/log_entry.dart';
import 'package:kafkax/l10n/app_localizations.dart';
import 'package:kafkax/presentation/providers/log_providers.dart';

/// Full-page log viewer with level filtering and search.
class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  LogLevel? _levelFilter;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _autoScroll = true;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_autoScroll || !_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  List<LogEntry> _filter(List<LogEntry> logs) {
    return logs.where((e) {
      if (_levelFilter != null && e.level != _levelFilter) return false;
      if (_searchQuery.isNotEmpty &&
          !e.message.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.extension<KafkaXColors>()!;
    final logsAsync = ref.watch(appLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.logPanelTitle),
        actions: [
          _LevelFilterChip(
            selected: _levelFilter,
            onSelected: (level) {
              setState(() {
                _levelFilter = _levelFilter == level ? null : level;
              });
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              _autoScroll
                  ? Icons.vertical_align_bottom
                  : Icons.vertical_align_bottom_outlined,
            ),
            onPressed: () => setState(() => _autoScroll = !_autoScroll),
            tooltip: 'Auto-scroll',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // TODO: clear logs via provider
            },
            tooltip: 'Clear logs',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: s.logSearchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
        ),
      ),
      body: logsAsync.when(
        data: (logs) {
          final filtered = _filter(logs);
          _scrollToBottom();
          if (filtered.isEmpty) {
            return Center(
              child: Text(
                s.noData,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            );
          }
          return _LogListView(
            entries: filtered,
            colors: colors,
            scrollController: _scrollController,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${s.error}: $e')),
      ),
    );
  }
}

class _LevelFilterChip extends StatelessWidget {
  const _LevelFilterChip({
    required this.selected,
    required this.onSelected,
  });

  final LogLevel? selected;
  final ValueChanged<LogLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chip(s.logLevelInfo, LogLevel.info, Colors.blue),
        _chip(s.logLevelWarn, LogLevel.warn, Colors.orange),
        _chip(s.logLevelError, LogLevel.error, Colors.red),
      ],
    );
  }

  Widget _chip(String label, LogLevel level, Color color) {
    final isSelected = selected == level;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(level),
        selectedColor: color.withValues(alpha: 0.2),
        checkmarkColor: color,
        labelStyle: TextStyle(
          color: isSelected ? color : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
    );
  }
}

class _LogListView extends StatelessWidget {
  const _LogListView({
    required this.entries,
    required this.colors,
    required this.scrollController,
  });

  final List<LogEntry> entries;
  final KafkaXColors colors;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monoStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: theme.textTheme.bodySmall?.fontSize ?? 12,
    );

    return ListView.builder(
      controller: scrollController,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _LogRow(
          entry: entry,
          monoStyle: monoStyle,
          theme: theme,
          colors: colors,
        );
      },
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({
    required this.entry,
    required this.monoStyle,
    required this.theme,
    required this.colors,
  });

  final LogEntry entry;
  final TextStyle monoStyle;
  final ThemeData theme;
  final KafkaXColors colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetail(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                _formatTime(entry.timestamp),
                style: monoStyle.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                entry.level.label,
                style: monoStyle.copyWith(
                  color: _levelColor(entry.level),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(entry.message, style: monoStyle),
            ),
          ],
        ),
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

  void _showDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _LogDetailDialog(entry: entry),
    );
  }
}

class _LogDetailDialog extends StatelessWidget {
  const _LogDetailDialog({required this.entry});

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Row(
        children: [
          Text('${entry.level.label} ', style: const TextStyle(fontSize: 16)),
          Text(
            _formatFullTime(entry.timestamp),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              entry.message,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
            if (entry.metadata != null && entry.metadata!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Metadata', style: theme.textTheme.labelMedium),
              const SizedBox(height: 4),
              SelectableText(
                entry.metadata!.entries
                    .map((e) => '${e.key}: ${e.value}')
                    .join('\n'),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Connection: ${entry.connectionId}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  String _formatFullTime(DateTime dt) =>
      '${dt.year}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}:'
      '${dt.second.toString().padLeft(2, '0')}';
}
