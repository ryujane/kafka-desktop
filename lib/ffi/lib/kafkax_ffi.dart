/// Barrel export for the KafkaX FFI layer.
///
/// Exposes generated bindings, native callbacks, and the library loader.
library kafkax_ffi;

export 'src/bindings/rd_kafka.dart';
export 'src/callbacks/rd_kafka_callbacks.dart';
export 'src/loader.dart';
