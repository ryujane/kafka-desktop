import 'package:flutter_test/flutter_test.dart';
import 'package:kafkax/data/models/log_entry.dart';

void main() {
  test('LogEntry holds all fields', () {
    final entry = LogEntry(
      timestamp: DateTime(2026, 1, 1, 10, 30),
      level: LogLevel.info,
      connectionId: 'conn-1',
      message: 'Connected to kafka1:9092',
    );
    expect(entry.level, LogLevel.info);
    expect(entry.connectionId, 'conn-1');
    expect(entry.message, 'Connected to kafka1:9092');
  });
}
