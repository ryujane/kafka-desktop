import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/data/models/broker_info.dart';
import 'package:kafkax/domain/kafka_service.dart';
import 'connection_providers.dart';

part 'cluster_providers.g.dart';

/// Fetches the list of brokers for the currently active connection.
@riverpod
Future<List<BrokerInfo>> brokerList(Ref ref) async {
  final activeConfig = ref.watch(activeConnectionProvider).value;
  if (activeConfig == null) return [];

  final isolateManager = ref.watch(ffiIsolateManagerProvider);
  final service = KafkaService(isolateManager);
  final metadata = await service.fetchMetadata(activeConfig.id);
  return metadata.brokers;
}
