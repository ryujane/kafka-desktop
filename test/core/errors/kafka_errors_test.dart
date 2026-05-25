import 'package:flutter_test/flutter_test.dart';
import 'package:kafkax/core/errors/kafka_errors.dart';

void main() {
  test('KafkaNativeError holds code and message', () {
    final err = KafkaNativeError(code: -127, message: 'Unknown error');
    expect(err.code, -127);
    expect(err.message, 'Unknown error');
    expect(err.toString(), contains('Unknown error'));
  });

  test('KafkaConnectionError holds broker', () {
    final err = KafkaConnectionError(
      broker: 'kafka1:9092',
      message: 'Connection refused',
    );
    expect(err.broker, 'kafka1:9092');
  });

  test('KafkaTimeoutError holds timeout duration', () {
    final err = KafkaTimeoutError(
      timeout: const Duration(seconds: 5),
      message: 'Timed out',
    );
    expect(err.timeout, const Duration(seconds: 5));
  });
}
