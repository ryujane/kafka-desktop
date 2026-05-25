import 'dart:convert';

class KafkaMessage {
  final int offset;
  final int partition;
  final String? key;
  final List<int> value;
  final DateTime timestamp;
  final Map<String, List<int>> headers;

  const KafkaMessage({
    required this.offset,
    required this.partition,
    this.key,
    required this.value,
    required this.timestamp,
    this.headers = const {},
  });

  String get valueAsString {
    try {
      return utf8.decode(value);
    } catch (_) {
      return value.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    }
  }
}
