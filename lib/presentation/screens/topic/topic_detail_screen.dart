import 'package:flutter/material.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(topicName),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Messages'),
              Tab(text: 'Config'),
              Tab(text: 'Metrics'),
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
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Messages for $topicName',
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              FilledButton.tonal(
                onPressed: () {
                  // TODO: Implement message consumption controls.
                },
                child: const Text('Start Consumer'),
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
    final theme = Theme.of(context);
    return DataTable(
      headingTextStyle: theme.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      columns: const [
        DataColumn(label: Text('Offset')),
        DataColumn(label: Text('Partition')),
        DataColumn(label: Text('Key')),
        DataColumn(label: Text('Value')),
        DataColumn(label: Text('Timestamp')),
      ],
      rows: const [],
    );
  }
}

/// Placeholder for the Config tab showing key-value table.
class _ConfigTabPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.settings_outlined, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text('Topic Configuration', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Key-value configuration entries will appear here.',
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
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart_outlined, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text('Topic Metrics', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Charts and graphs will appear here.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
