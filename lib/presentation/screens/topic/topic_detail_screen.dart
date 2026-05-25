import 'package:flutter/material.dart';

import 'package:kafkax/l10n/app_localizations.dart';

/// Detailed view of a single topic with Messages, Config, and Metrics tabs.
class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({
    required this.clusterId,
    required this.topicName,
    super.key,
  });

  /// The cluster (connection) identifier.
  final String clusterId;

  /// The topic name.
  final String topicName;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(topicName),
          bottom: TabBar(
            tabs: [
              Tab(text: s.topicMessages),
              Tab(text: s.topicConfig),
              Tab(text: s.topicMetrics),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MessagesTabPlaceholder(topicName: topicName),
            _ConfigTabPlaceholder(),
            _MetricsTabPlaceholder(),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the Messages tab with a DataTable structure.
class _MessagesTabPlaceholder extends StatelessWidget {
  const _MessagesTabPlaceholder({required this.topicName});

  final String topicName;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${s.topicMessages}: $topicName',
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              FilledButton.tonal(
                onPressed: () {
                  // TODO: Implement message consumption controls.
                },
                child: Text(s.producerSend),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Placeholder DataTable structure.
                _MessageDataTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Placeholder data table for messages.
class _MessageDataTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    return DataTable(
      headingTextStyle: theme.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      columns: [
        DataColumn(label: Text(s.topicOffset)),
        DataColumn(label: Text(s.topicPartitions)),
        DataColumn(label: Text(s.topicKey)),
        DataColumn(label: Text(s.topicValue)),
        DataColumn(label: Text(s.topicTimestamp)),
      ],
      rows: const [],
    );
  }
}

/// Placeholder for the Config tab showing key-value table.
class _ConfigTabPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.settings_outlined, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(s.topicConfig, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            s.noData,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder for the Metrics tab.
class _MetricsTabPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart_outlined, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(s.topicMetrics, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            s.noData,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
