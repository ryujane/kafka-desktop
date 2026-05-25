import 'package:flutter_test/flutter_test.dart';
import 'package:kafkax/data/models/connection_config.dart';
import 'package:kafkax/data/repositories/connection_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ConnectionRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repo = ConnectionRepository(prefs);
  });

  test('saves and loads connections', () async {
    final config = ConnectionConfig(name: 'Test', brokers: 'localhost:9092');
    await repo.save(config);
    final loaded = await repo.loadAll();
    expect(loaded.length, 1);
    expect(loaded.first.name, 'Test');
    expect(loaded.first.brokers, 'localhost:9092');
  });

  test('deletes a connection', () async {
    final config = ConnectionConfig(
      name: 'ToDelete',
      brokers: 'localhost:9092',
    );
    await repo.save(config);
    await repo.delete(config.id);
    final loaded = await repo.loadAll();
    expect(loaded, isEmpty);
  });

  test('updates existing connection', () async {
    final config = ConnectionConfig(
      name: 'Original',
      brokers: 'localhost:9092',
    );
    await repo.save(config);
    final updated = ConnectionConfig(
      id: config.id,
      name: 'Updated',
      brokers: 'kafka1:9092',
    );
    await repo.save(updated);
    final loaded = await repo.loadAll();
    expect(loaded.length, 1);
    expect(loaded.first.name, 'Updated');
  });
}
