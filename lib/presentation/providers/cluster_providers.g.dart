// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cluster_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches the list of brokers for the currently active connection.

@ProviderFor(brokerList)
final brokerListProvider = BrokerListProvider._();

/// Fetches the list of brokers for the currently active connection.

final class BrokerListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BrokerInfo>>,
          List<BrokerInfo>,
          FutureOr<List<BrokerInfo>>
        >
    with $FutureModifier<List<BrokerInfo>>, $FutureProvider<List<BrokerInfo>> {
  /// Fetches the list of brokers for the currently active connection.
  BrokerListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brokerListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brokerListHash();

  @$internal
  @override
  $FutureProviderElement<List<BrokerInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BrokerInfo>> create(Ref ref) {
    return brokerList(ref);
  }
}

String _$brokerListHash() => r'a4dd13c53a19ec5ec8d48a2eade5213769794d40';
