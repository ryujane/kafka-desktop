// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the producer state for sending messages.

@ProviderFor(ProducerState)
final producerStateProvider = ProducerStateProvider._();

/// Manages the producer state for sending messages.
final class ProducerStateProvider
    extends $NotifierProvider<ProducerState, ProducerStatus> {
  /// Manages the producer state for sending messages.
  ProducerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'producerStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$producerStateHash();

  @$internal
  @override
  ProducerState create() => ProducerState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProducerStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProducerStatus>(value),
    );
  }
}

String _$producerStateHash() => r'0e0a013256ab1026dc549a06a153abace629ac74';

/// Manages the producer state for sending messages.

abstract class _$ProducerState extends $Notifier<ProducerStatus> {
  ProducerStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProducerStatus, ProducerStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProducerStatus, ProducerStatus>,
              ProducerStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
