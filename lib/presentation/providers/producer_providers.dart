import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/domain/kafka_service.dart';
import 'connection_providers.dart';

part 'producer_providers.g.dart';

/// Manages the producer state for sending messages.
@riverpod
class ProducerState extends _$ProducerState {
  @override
  ProducerStatus build() => const ProducerStatus.idle();

  /// Produces a message to the specified topic.
  Future<ProduceResult> produce({
    required String topic,
    required List<int> value,
    List<int>? key,
    int? partition,
    Map<String, List<int>>? headers,
  }) async {
    final activeConfig = ref.read(activeConnectionProvider).value;
    if (activeConfig == null) {
      throw StateError('No active connection');
    }

    state = const ProducerStatus.sending();

    try {
      final isolateManager = ref.read(ffiIsolateManagerProvider);
      final service = KafkaService(isolateManager);
      final result = await service.produce(
        connectionId: activeConfig.id,
        topic: topic,
        value: value,
        key: key,
        partition: partition,
        headers: headers,
      );
      state = ProducerStatus.success(result);
      return result;
    } catch (e) {
      state = ProducerStatus.error(e.toString());
      rethrow;
    }
  }

  /// Resets the producer state to idle.
  void reset() {
    state = const ProducerStatus.idle();
  }
}

/// Status of a produce operation.
sealed class ProducerStatus {
  const ProducerStatus();

  /// Idle, no operation in progress.
  const factory ProducerStatus.idle() = _Idle;

  /// Currently sending a message.
  const factory ProducerStatus.sending() = _Sending;

  /// Message was successfully produced.
  const factory ProducerStatus.success(ProduceResult result) = _Success;

  /// An error occurred while producing.
  const factory ProducerStatus.error(String message) = _Error;
}

class _Idle extends ProducerStatus {
  const _Idle();
}

class _Sending extends ProducerStatus {
  const _Sending();
}

class _Success extends ProducerStatus {
  final ProduceResult result;
  const _Success(this.result);
}

class _Error extends ProducerStatus {
  final String message;
  const _Error(this.message);
}
