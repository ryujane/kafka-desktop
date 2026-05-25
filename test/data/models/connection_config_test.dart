import 'package:flutter_test/flutter_test.dart';
import 'package:kafkax/data/models/connection_config.dart';

void main() {
  test('ConnectionConfig round-trips through JSON', () {
    final config = ConnectionConfig(
      name: 'Test Cluster',
      brokers: 'kafka1:9092,kafka2:9092',
      auth: const AuthConfig(
        type: AuthType.saslPlain,
        username: 'user',
        password: 'pass',
      ),
      tls: const TlsConfig(enabled: true, caCertPath: '/path/to/ca.crt'),
      properties: {'socket.timeout.ms': '5000'},
    );
    final json = config.toJson();
    final restored = ConnectionConfig.fromJson(json);
    expect(restored.id, config.id);
    expect(restored.name, config.name);
    expect(restored.brokers, config.brokers);
    expect(restored.auth?.type, AuthType.saslPlain);
    expect(restored.tls?.enabled, true);
    expect(restored.properties, config.properties);
  });

  test('ConnectionConfig generates UUID when id is empty', () {
    final config = ConnectionConfig(name: 'No ID', brokers: 'localhost:9092');
    expect(config.id, isNotEmpty);
  });
}
