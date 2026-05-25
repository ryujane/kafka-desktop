import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/data/models/topic_info.dart';
import 'package:kafkax/domain/kafka_service.dart';
import 'connection_providers.dart';

part 'topic_providers.g.dart';

/// Fetches the list of topics for the currently active connection.
@riverpod
Future<List<TopicInfo>> topicList(Ref ref) async {
  final activeConfig = ref.watch(activeConnectionProvider).value;
  if (activeConfig == null) return [];

  final isolateManager = ref.watch(ffiIsolateManagerProvider);
  final service = KafkaService(isolateManager);
  return service.listTopics(activeConfig.id);
}

/// Fetches detailed information for a specific topic.
@riverpod
Future<TopicDetail> topicDetail(Ref ref, String topicName) async {
  final activeConfig = ref.watch(activeConnectionProvider).value;
  if (activeConfig == null) {
    throw StateError('No active connection');
  }

  final isolateManager = ref.watch(ffiIsolateManagerProvider);
  final service = KafkaService(isolateManager);
  final metadata = await service.fetchMetadata(activeConfig.id);

  final topic = metadata.topics.where((t) => t.name == topicName).firstOrNull;
  if (topic == null) {
    throw StateError('Topic "$topicName" not found');
  }

  return TopicDetail(info: topic, brokerCount: metadata.brokers.length);
}

/// Wrapper for topic detail data including broker count.
class TopicDetail {
  /// Topic information.
  final TopicInfo info;

  /// Number of brokers in the cluster.
  final int brokerCount;

  const TopicDetail({required this.info, required this.brokerCount});
}
