import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kafkax/data/models/kafka_message.dart';

void main() {
  test('KafkaMessage holds all fields', () {
    final msg = KafkaMessage(
      offset: 42,
      partition: 0,
      key: 'my-key',
      value: utf8.encode('hello'),
      timestamp: DateTime(2026, 1, 1),
      headers: {'source': utf8.encode('test')},
    );
    expect(msg.offset, 42);
    expect(msg.key, 'my-key');
    expect(utf8.decode(msg.value), 'hello');
  });

  test('KafkaMessage.valueAsString decodes UTF-8', () {
    final msg = KafkaMessage(
      offset: 0,
      partition: 0,
      value: utf8.encode('{"key": "value"}'),
      timestamp: DateTime.now(),
    );
    expect(msg.valueAsString, '{"key": "value"}');
  });
}
