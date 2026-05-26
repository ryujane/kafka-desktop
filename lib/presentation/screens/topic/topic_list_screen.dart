import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/l10n/app_localizations.dart';
import 'package:kafkax/presentation/providers/navigation_providers.dart';
import 'package:kafkax/presentation/providers/topic_providers.dart';

/// Screen listing all topics for a given cluster.
class TopicListScreen extends ConsumerWidget {
  const TopicListScreen({required this.clusterId, super.key});

  /// The cluster (connection) identifier.
  final String clusterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    final topicsAsync = ref.watch(topicListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.topicList),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(topicListProvider),
            tooltip: 'Refresh topics',
          ),
        ],
      ),
      body: topicsAsync.when(
        data: (topics) {
          if (topics.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.topic_outlined,
                    size: 48,
                    color: theme.disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(s.noData, style: theme.textTheme.bodyLarge),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return ListTile(
                leading: const Icon(Icons.topic_outlined),
                title: Text(topic.name),
                subtitle: Text(
                  '${s.topicPartitions}: ${topic.partitions.length}  |  '
                  '${s.topicIsInternal}: ${topic.isInternal}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(navigationProvider.notifier).go(
                    NavTopicDetail(clusterId: clusterId, topicName: topic.name),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${s.error}: $e')),
      ),
    );
  }
}
