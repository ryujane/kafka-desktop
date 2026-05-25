// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumer_group_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches the list of consumer groups for the active connection.

@ProviderFor(groupList)
final groupListProvider = GroupListProvider._();

/// Fetches the list of consumer groups for the active connection.

final class GroupListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ConsumerGroup>>,
          List<ConsumerGroup>,
          FutureOr<List<ConsumerGroup>>
        >
    with
        $FutureModifier<List<ConsumerGroup>>,
        $FutureProvider<List<ConsumerGroup>> {
  /// Fetches the list of consumer groups for the active connection.
  GroupListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupListHash();

  @$internal
  @override
  $FutureProviderElement<List<ConsumerGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ConsumerGroup>> create(Ref ref) {
    return groupList(ref);
  }
}

String _$groupListHash() => r'f282bfb2c43a6e92bf769add93b955d6c11ee2f6';
