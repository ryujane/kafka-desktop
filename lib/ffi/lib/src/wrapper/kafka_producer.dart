import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../bindings/rd_kafka.dart';
import 'kafka_config.dart';

/// Dart-idiomatic wrapper around a native rd_kafka_t producer handle.
///
/// Ownership of the [KafkaConfig] transfers to this producer on successful
/// creation. Call [dispose] when the producer is no longer needed.
class KafkaProducer {
  late final LibRdKafka bindings;
  Pointer<rd_kafka_t>? _rk;
  bool _disposed = false;

  KafkaProducer(DynamicLibrary dl, KafkaConfig config)
    : bindings = LibRdKafka(dl) {
    final errBuf = malloc.allocate<Utf8>(512).cast<Utf8>();
    try {
      _rk = bindings.rd_kafka_new(
        rd_kafka_type_t.RD_KAFKA_PRODUCER,
        config.nativePtr,
        errBuf.cast(),
        512,
      );
      if (_rk == nullptr) {
        throw StateError('Failed to create producer: ${errBuf.toDartString()}');
      }
    } finally {
      malloc.free(errBuf);
    }
  }

  /// The underlying native pointer (null after [dispose]).
  Pointer<rd_kafka_t>? get nativePtr => _rk;

  /// Polls the producer for delivery reports and other callbacks.
  ///
  /// Should be called regularly to trigger delivery report callbacks.
  /// Returns the number of events served.
  int poll(int timeoutMs) {
    _checkNotDisposed();
    return bindings.rd_kafka_poll(_rk!, timeoutMs);
  }

  /// Flushes all outstanding produce requests.
  ///
  /// Should be called before disposing the producer to ensure all
  /// queued messages are delivered.
  ///
  /// Returns [rd_kafka_resp_err_t.RD_KAFKA_RESP_ERR_NO_ERROR] on success
  /// or [rd_kafka_resp_err_t.RD_KAFKA_RESP_ERR__TIMED_OUT] if the timeout
  /// was reached before all messages were delivered.
  rd_kafka_resp_err_t flush(int timeoutMs) {
    _checkNotDisposed();
    return bindings.rd_kafka_flush(_rk!, timeoutMs);
  }

  /// Produces a message to the given topic and partition.
  ///
  /// [topic] is the topic name. [partition] is the target partition
  /// (use -1 / RD_KAFKA_PARTITION_UA for automatic partitioning).
  /// [payload] and [key] are optional byte data.
  ///
  // TODO: Implement produce with careful pointer management for payload,
  // key, and topic handle lifecycle. This requires:
  // 1. Creating an rd_kafka_topic_t via rd_kafka_topic_new
  // 2. Allocating native memory for payload and key
  // 3. Calling rd_kafka_produce with the correct msgflags
  // 4. Freeing topic handle and any temporary allocations
  // 5. Handling rd_kafka_last_error() on failure (-1 return)
  void produce({
    required String topic,
    int partition = -1,
    List<int>? payload,
    List<int>? key,
  }) {
    throw UnimplementedError(
      'produce() requires careful pointer management - '
      'to be implemented in a follow-up task',
    );
  }

  void _checkNotDisposed() {
    if (_disposed || _rk == null) {
      throw StateError('Producer has been disposed');
    }
  }

  /// Destroys the native producer handle.
  ///
  /// Implicitly calls [rd_kafka_consumer_close] if needed and blocks
  /// until all outstanding requests are completed.
  void dispose() {
    if (!_disposed && _rk != null) {
      bindings.rd_kafka_destroy(_rk!);
      _rk = null;
      _disposed = true;
    }
  }
}
