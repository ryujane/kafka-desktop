// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of Kafka messages for a given topic on the active connection.

@ProviderFor(messageStream)
final messageStreamProvider = MessageStreamFamily._();

/// Stream of Kafka messages for a given topic on the active connection.

final class MessageStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<KafkaMessage>,
          KafkaMessage,
          Stream<KafkaMessage>
        >
    with $FutureModifier<KafkaMessage>, $StreamProvider<KafkaMessage> {
  /// Stream of Kafka messages for a given topic on the active connection.
  MessageStreamProvider._({
    required MessageStreamFamily super.from,
    required (String, {int? partition, int? offset}) super.argument,
  }) : super(
         retry: null,
         name: r'messageStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messageStreamHash();

  @override
  String toString() {
    return r'messageStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<KafkaMessage> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<KafkaMessage> create(Ref ref) {
    final argument = this.argument as (String, {int? partition, int? offset});
    return messageStream(
      ref,
      argument.$1,
      partition: argument.partition,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MessageStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageStreamHash() => r'd8ea78e9654c1c1222a74af7e025a9046cbe273c';

/// Stream of Kafka messages for a given topic on the active connection.

final class MessageStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<KafkaMessage>,
          (String, {int? partition, int? offset})
        > {
  MessageStreamFamily._()
    : super(
        retry: null,
        name: r'messageStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Stream of Kafka messages for a given topic on the active connection.

  MessageStreamProvider call(String topic, {int? partition, int? offset}) =>
      MessageStreamProvider._(
        argument: (topic, partition: partition, offset: offset),
        from: this,
      );

  @override
  String toString() => r'messageStreamProvider';
}
