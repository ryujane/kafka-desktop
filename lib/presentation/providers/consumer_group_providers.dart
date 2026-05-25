import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/data/models/consumer_group.dart';
import 'package:kafkax/domain/kafka_service.dart';
import 'connection_providers.dart';

part 'consumer_group_providers.g.dart';

/// Fetches the list of consumer groups for the active connection.
@riverpod
Future<List<ConsumerGroup>> groupList(Ref ref) async {
  final activeConfig = ref.watch(activeConnectionProvider).value;
  if (activeConfig == null) return [];

  final isolateManager = ref.watch(ffiIsolateManagerProvider);
  final service = KafkaService(isolateManager);
  return service.listGroups(activeConfig.id);
}
