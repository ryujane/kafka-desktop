import 'dart:async';

import 'package:kafkax/data/models/broker_info.dart';
import 'package:kafkax/data/models/consumer_group.dart';
import 'package:kafkax/data/models/kafka_message.dart';
import 'package:kafkax/data/models/topic_info.dart';
import 'package:kafkax/ffi/lib/src/isolate/ffi_isolate.dart';
import 'package:kafkax/ffi/lib/src/isolate/ffi_messages.dart';

/// Unified facade for all Kafka operations.
///
/// Delegates every call to [FfiIsolateManager] and converts the raw
/// [FfiResponse] data into domain model types.
class KafkaService {
  final FfiIsolateManager _isolateManager;

  KafkaService(this._isolateManager);

  // ---------------------------------------------------------------------------
  // Topics
  // ---------------------------------------------------------------------------

  /// Lists all topics on the cluster identified by [connectionId].
  Future<List<TopicInfo>> listTopics(String connectionId) async {
    final response = await _isolateManager.send<TopicListResponse>(
      ListTopicsRequest(connectionId),
    );
    return response.topics.map(TopicInfo.fromJson).toList();
  }

  /// Creates a new topic.
  Future<void> createTopic({
    required String connectionId,
    required String name,
    required int partitions,
    required int replicationFactor,
    Map<String, String> config = const {},
  }) async {
    final response = await _isolateManager.send<TopicActionResponse>(
      CreateTopicRequest(
        connectionId: connectionId,
        name: name,
        partitions: partitions,
        replicationFactor: replicationFactor,
        config: config,
      ),
    );
    if (!response.success) {
      throw KafkaServiceException(
        connectionId: connectionId,
        message: response.error ?? 'Failed to create topic "$name"',
      );
    }
  }

  /// Deletes a topic.
  Future<void> deleteTopic({
    required String connectionId,
    required String topicName,
  }) async {
    final response = await _isolateManager.send<TopicActionResponse>(
      DeleteTopicRequest(connectionId: connectionId, topicName: topicName),
    );
    if (!response.success) {
      throw KafkaServiceException(
        connectionId: connectionId,
        message: response.error ?? 'Failed to delete topic "$topicName"',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Consume / Produce
  // ---------------------------------------------------------------------------

  /// Consumes messages from a topic and returns them as a [Stream].
  ///
  /// Sends a [ConsumeRequest] then listens to [MessageEvent]s on the
  /// isolate's response stream until EOF is signalled.
  Stream<KafkaMessage> consumeMessages({
    required String connectionId,
    required String topic,
    int? partition,
    int? offset,
    int maxMessages = 500,
  }) async* {
    // Send the consume request to start the consumer.
    await _isolateManager.send<MessageEvent>(
      ConsumeRequest(
        connectionId: connectionId,
        topic: topic,
        partition: partition,
        offset: offset,
        maxMessages: maxMessages,
      ),
    );

    // Yield messages from subsequent MessageEvent responses.
    await for (final response in _isolateManager.responses) {
      if (response.connectionId != connectionId) continue;
      if (response is! MessageEvent) continue;

      for (final raw in response.messages) {
        yield _parseMessage(raw);
      }

      if (response.eof) break;
    }
  }

  /// Stops an active consumer for the given [connectionId].
  Future<void> stopConsume(String connectionId) async {
    _isolateManager.send<DisconnectResponse>(StopConsumeRequest(connectionId));
  }

  /// Produces a single message to a topic.
  ///
  /// Returns a [ProduceResult] with the partition and offset on success.
  Future<ProduceResult> produce({
    required String connectionId,
    required String topic,
    required List<int> value,
    List<int>? key,
    int? partition,
    Map<String, List<int>>? headers,
  }) async {
    final response = await _isolateManager.send<ProduceResponse>(
      ProduceRequest(
        connectionId: connectionId,
        topic: topic,
        value: value,
        key: key,
        partition: partition,
        headers: headers,
      ),
    );

    if (!response.success) {
      throw KafkaServiceException(
        connectionId: connectionId,
        message: response.error ?? 'Failed to produce message',
      );
    }

    return ProduceResult(
      partition: response.partition ?? -1,
      offset: response.offset ?? -1,
    );
  }

  // ---------------------------------------------------------------------------
  // Consumer Groups
  // ---------------------------------------------------------------------------

  /// Lists all consumer groups on the cluster.
  Future<List<ConsumerGroup>> listGroups(String connectionId) async {
    final response = await _isolateManager.send<GroupListResponse>(
      ListGroupsRequest(connectionId),
    );
    return response.groups.map(_parseGroup).toList();
  }

  /// Resets offsets for a consumer group on a specific topic.
  Future<void> resetOffsets({
    required String connectionId,
    required String groupId,
    required String topicName,
    required int offset,
  }) async {
    final response = await _isolateManager.send<OffsetResetResponse>(
      ResetOffsetsRequest(
        connectionId: connectionId,
        groupId: groupId,
        topicName: topicName,
        offset: offset,
      ),
    );
    if (!response.success) {
      throw KafkaServiceException(
        connectionId: connectionId,
        message: response.error ?? 'Failed to reset offsets',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Metadata
  // ---------------------------------------------------------------------------

  /// Fetches cluster metadata (brokers and topics).
  Future<ClusterMetadata> fetchMetadata(String connectionId) async {
    final response = await _isolateManager.send<MetadataResponse>(
      ListTopicsRequest(connectionId),
    );
    return ClusterMetadata(
      brokers: response.brokers.map(_parseBroker).toList(),
      topics: response.topics.map(TopicInfo.fromJson).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Parsing helpers
  // ---------------------------------------------------------------------------

  static KafkaMessage _parseMessage(Map<String, dynamic> raw) {
    return KafkaMessage(
      offset: raw['offset'] as int,
      partition: raw['partition'] as int,
      key: raw['key'] as String?,
      value: List<int>.from(raw['value'] as List),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        raw['timestamp'] as int? ?? 0,
      ),
      headers: _parseHeaders(raw['headers'] as Map<String, dynamic>?),
    );
  }

  static Map<String, List<int>> _parseHeaders(Map<String, dynamic>? raw) {
    if (raw == null) return const {};
    return raw.map((k, v) => MapEntry(k, List<int>.from(v as List)));
  }

  static ConsumerGroup _parseGroup(Map<String, dynamic> raw) {
    return ConsumerGroup(
      groupId: raw['group_id'] as String? ?? raw['groupId'] as String? ?? '',
      state: raw['state'] as String? ?? 'Unknown',
      members:
          (raw['members'] as List?)
              ?.map(
                (m) => GroupMember(
                  memberId:
                      (m as Map<String, dynamic>)['member_id'] as String? ?? '',
                  clientId:
                      m['client_id'] as String? ??
                      m['clientId'] as String? ??
                      '',
                  clientHost:
                      m['client_host'] as String? ??
                      m['clientHost'] as String? ??
                      '',
                  assignments: List<int>.from(m['assignments'] as List? ?? []),
                ),
              )
              .toList() ??
          [],
      protocolType: raw['protocol_type'] as String? ?? 'consumer',
    );
  }

  static BrokerInfo _parseBroker(Map<String, dynamic> raw) {
    return BrokerInfo(
      id: raw['id'] as int,
      host: raw['host'] as String,
      port: raw['port'] as int,
      rack: raw['rack'] as String?,
    );
  }
}

/// Result of a successful produce operation.
class ProduceResult {
  final int partition;
  final int offset;

  const ProduceResult({required this.partition, required this.offset});
}

/// Cluster metadata containing brokers and topics.
class ClusterMetadata {
  final List<BrokerInfo> brokers;
  final List<TopicInfo> topics;

  const ClusterMetadata({required this.brokers, required this.topics});
}

/// Exception thrown when a Kafka operation fails.
class KafkaServiceException implements Exception {
  final String connectionId;
  final String message;

  const KafkaServiceException({
    required this.connectionId,
    required this.message,
  });

  @override
  String toString() => 'KafkaServiceException($connectionId): $message';
}
