import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../bindings/rd_kafka.dart';
import 'kafka_config.dart';

/// Dart-idiomatic wrapper around a native rd_kafka_t consumer handle.
///
/// Ownership of the [KafkaConfig] transfers to this consumer on successful
/// creation. Call [dispose] when the consumer is no longer needed.
class KafkaConsumer {
  late final LibRdKafka _bindings;
  Pointer<rd_kafka_t>? _rk;
  bool _disposed = false;

  KafkaConsumer(DynamicLibrary dl, KafkaConfig config)
    : _bindings = LibRdKafka(dl) {
    final errBuf = malloc.allocate<Utf8>(512).cast<Utf8>();
    try {
      _rk = _bindings.rd_kafka_new(
        rd_kafka_type_t.RD_KAFKA_CONSUMER,
        config.nativePtr,
        errBuf.cast(),
        512,
      );
      if (_rk == nullptr) {
        throw StateError('Failed to create consumer: ${errBuf.toDartString()}');
      }
    } finally {
      malloc.free(errBuf);
    }
  }

  /// The underlying native pointer (null after [dispose]).
  Pointer<rd_kafka_t>? get nativePtr => _rk;

  /// Subscribes to the given list of topic names.
  ///
  // TODO: Implement subscribe using rd_kafka_subscribe.
  // This requires:
  // 1. Creating an rd_kafka_topic_partition_list_t via
  //    rd_kafka_topic_partition_list_new(topics.length)
  // 2. Adding each topic via rd_kafka_topic_partition_list_add
  // 3. Calling rd_kafka_subscribe(_rk, list)
  // 4. Destroying the topic partition list
  // 5. Checking the returned rd_kafka_resp_err_t
  void subscribe(List<String> topics) {
    throw UnimplementedError(
      'subscribe() requires rd_kafka_topic_partition_list_t '
      'management - to be implemented in a follow-up task',
    );
  }

  /// Unsubscribes from the current subscription set.
  rd_kafka_resp_err_t unsubscribe() {
    _checkNotDisposed();
    return _bindings.rd_kafka_unsubscribe(_rk!);
  }

  /// Consumes a single message from the consumer.
  ///
  /// Returns null if no message is available within [timeoutMs].
  ///
  // TODO: Implement consume using rd_kafka_consumer_poll (or the legacy
  // rd_kafka_consume API). This requires:
  // 1. Calling rd_kafka_consumer_poll or rd_kafka_consume
  // 2. Checking the returned rd_kafka_message_t for errors
  // 3. Extracting payload, key, topic, partition, offset
  // 4. Destroying the message via rd_kafka_message_destroy
  // 5. Returning a Dart-friendly message object
  void consume({int timeoutMs = 1000}) {
    throw UnimplementedError(
      'consume() requires careful message lifecycle management '
      '- to be implemented in a follow-up task',
    );
  }

  /// Closes the consumer, revoking its assignment and leaving the group.
  ///
  /// This is called automatically by [dispose], but can be called
  /// explicitly for finer control.
  rd_kafka_resp_err_t close() {
    _checkNotDisposed();
    return _bindings.rd_kafka_consumer_close(_rk!);
  }

  void _checkNotDisposed() {
    if (_disposed || _rk == null) {
      throw StateError('Consumer has been disposed');
    }
  }

  /// Destroys the native consumer handle.
  ///
  /// Implicitly calls [rd_kafka_consumer_close] if a group.id was configured.
  void dispose() {
    if (!_disposed && _rk != null) {
      _bindings.rd_kafka_destroy(_rk!);
      _rk = null;
      _disposed = true;
    }
  }
}
