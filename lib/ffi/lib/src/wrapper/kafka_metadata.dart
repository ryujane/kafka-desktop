import '../bindings/rd_kafka.dart';
import 'kafka_producer.dart';

/// Dart-idiomatic wrapper around the native Kafka metadata API.
///
/// Provides access to broker, topic, and partition metadata from the
/// Kafka cluster.
class KafkaMetadata {
  // ignore: unused_field - will be used when fetch() is implemented
  late final LibRdKafka _bindings;
  // ignore: unused_field - will be used when fetch() is implemented
  final KafkaProducer _producer;

  KafkaMetadata(this._producer) : _bindings = _producer.bindings;

  /// Fetches metadata from the Kafka cluster.
  ///
  /// When [allTopics] is true, metadata for all topics in the cluster
  /// is requested. When false, only locally known topics are returned.
  /// If [topic] is provided, only metadata for that specific topic is
  /// fetched.
  ///
  /// Returns a [ClusterMetadata] object on success.
  ///
  // TODO: Implement fetch using rd_kafka_metadata. This requires:
  // 1. Allocating a Pointer<Pointer<rd_kafka_metadata$1>> for the result
  // 2. Optionally creating an rd_kafka_topic_t for the only_rkt parameter
  // 3. Calling rd_kafka_metadata(_rk, all_topics, only_rkt, &metadatap, timeout)
  // 4. Iterating over brokers, topics, and partitions in the result struct
  // 5. Converting to Dart-friendly ClusterMetadata / BrokerMetadata /
  //    TopicMetadata / PartitionMetadata objects
  // 6. Calling rd_kafka_metadata_destroy to free the result
  ClusterMetadata fetch({
    bool allTopics = true,
    String? topic,
    int timeoutMs = 5000,
  }) {
    throw UnimplementedError(
      'fetch() requires metadata struct traversal '
      '- to be implemented in a follow-up task',
    );
  }
}

/// Cluster-wide metadata returned by [KafkaMetadata.fetch].
class ClusterMetadata {
  final List<BrokerMetadata> brokers;
  final List<TopicMetadata> topics;

  const ClusterMetadata({required this.brokers, required this.topics});
}

/// Metadata for a single broker.
class BrokerMetadata {
  final int id;
  final String host;
  final int port;

  const BrokerMetadata({
    required this.id,
    required this.host,
    required this.port,
  });
}

/// Metadata for a single topic.
class TopicMetadata {
  final String name;
  final List<PartitionMetadata> partitions;

  const TopicMetadata({required this.name, required this.partitions});
}

/// Metadata for a single partition.
class PartitionMetadata {
  final int id;
  final int leader;
  final List<int> replicas;
  final List<int> isrs;

  const PartitionMetadata({
    required this.id,
    required this.leader,
    required this.replicas,
    required this.isrs,
  });
}
