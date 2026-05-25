import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../bindings/rd_kafka.dart';

/// Dart-idiomatic wrapper around the native rd_kafka_conf_t handle.
///
/// Provides safe configuration of a Kafka client instance before creation.
/// Once a config is passed to [KafkaProducer] or [KafkaConsumer], ownership
/// transfers to the native layer and [dispose] must not be called.
class KafkaConfig {
  late final LibRdKafka _bindings;
  late final Pointer<rd_kafka_conf_t> _conf;
  bool _disposed = false;

  KafkaConfig(DynamicLibrary dl) : _bindings = LibRdKafka(dl) {
    _conf = _bindings.rd_kafka_conf_new();
  }

  /// The underlying native pointer.
  ///
  /// Used when passing the config to [KafkaProducer] or [KafkaConsumer].
  Pointer<rd_kafka_conf_t> get nativePtr => _conf;

  /// Sets a single configuration property.
  ///
  /// Throws [StateError] if the property name is unknown or the value is
  /// invalid.
  void set(String key, String value) {
    final errBuf = malloc.allocate<Utf8>(512).cast<Utf8>();
    final keyPtr = key.toNativeUtf8();
    final valPtr = value.toNativeUtf8();
    try {
      final result = _bindings.rd_kafka_conf_set(
        _conf,
        keyPtr.cast(),
        valPtr.cast(),
        errBuf.cast(),
        512,
      );
      if (result != rd_kafka_conf_res_t.RD_KAFKA_CONF_OK) {
        throw StateError('Config error for "$key": ${errBuf.toDartString()}');
      }
    } finally {
      malloc.free(keyPtr);
      malloc.free(valPtr);
      malloc.free(errBuf);
    }
  }

  /// Convenience method to set the bootstrap broker addresses.
  void setBrokerAddress(String brokers) {
    set('bootstrap.servers', brokers);
  }

  /// Sets the group.id for consumer instances.
  void setGroupId(String groupId) {
    set('group.id', groupId);
  }

  /// Releases the native config object.
  ///
  /// Do not call this after the config has been passed to a producer or
  /// consumer constructor, because ownership transfers to the native layer
  /// on a successful [rd_kafka_new] call.
  void dispose() {
    if (!_disposed) {
      _bindings.rd_kafka_conf_destroy(_conf);
      _disposed = true;
    }
  }
}
