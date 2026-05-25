import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/data/models/kafka_message.dart';
import 'package:kafkax/domain/kafka_service.dart';
import 'connection_providers.dart';

part 'message_providers.g.dart';

/// Stream of Kafka messages for a given topic on the active connection.
@riverpod
Stream<KafkaMessage> messageStream(
  Ref ref,
  String topic, {
  int? partition,
  int? offset,
}) {
  final activeConfig = ref.watch(activeConnectionProvider).value;
  if (activeConfig == null) {
    return const Stream.empty();
  }

  final isolateManager = ref.watch(ffiIsolateManagerProvider);
  final service = KafkaService(isolateManager);

  return service.consumeMessages(
    connectionId: activeConfig.id,
    topic: topic,
    partition: partition,
    offset: offset,
  );
}
