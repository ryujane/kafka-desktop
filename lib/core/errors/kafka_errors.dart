sealed class KafkaError implements Exception {
  final String message;
  KafkaError(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class KafkaNativeError extends KafkaError {
  final int code;
  KafkaNativeError({required this.code, required String message})
    : super(message);
}

class KafkaConnectionError extends KafkaError {
  final String broker;
  KafkaConnectionError({required this.broker, required String message})
    : super(message);
}

class KafkaTimeoutError extends KafkaError {
  final Duration timeout;
  KafkaTimeoutError({required this.timeout, required String message})
    : super(message);
}

class StorageError extends KafkaError {
  StorageError(super.message);
}
