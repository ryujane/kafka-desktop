import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/presentation/providers/topic_providers.dart';

/// Screen listing all topics for a given cluster.
class TopicListScreen extends ConsumerWidget {
  const TopicListScreen({required this.clusterId, super.key});

  /// The cluster (connection) identifier.
  final String clusterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final topicsAsync = ref.watch(topicListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
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
                  Text('No topics found.', style: theme.textTheme.bodyLarge),
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
                  'Partitions: ${topic.partitions.length}  |  '
                  'Internal: ${topic.isInternal}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.go('/cluster/$clusterId/topics/${topic.name}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
