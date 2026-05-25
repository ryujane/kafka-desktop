// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches the list of topics for the currently active connection.

@ProviderFor(topicList)
final topicListProvider = TopicListProvider._();

/// Fetches the list of topics for the currently active connection.

final class TopicListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TopicInfo>>,
          List<TopicInfo>,
          FutureOr<List<TopicInfo>>
        >
    with $FutureModifier<List<TopicInfo>>, $FutureProvider<List<TopicInfo>> {
  /// Fetches the list of topics for the currently active connection.
  TopicListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topicListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topicListHash();

  @$internal
  @override
  $FutureProviderElement<List<TopicInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TopicInfo>> create(Ref ref) {
    return topicList(ref);
  }
}

String _$topicListHash() => r'c6ae485840c54236590184e55cc791390b2ab57a';

/// Fetches detailed information for a specific topic.

@ProviderFor(topicDetail)
final topicDetailProvider = TopicDetailFamily._();

/// Fetches detailed information for a specific topic.

final class TopicDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<TopicDetail>,
          TopicDetail,
          FutureOr<TopicDetail>
        >
    with $FutureModifier<TopicDetail>, $FutureProvider<TopicDetail> {
  /// Fetches detailed information for a specific topic.
  TopicDetailProvider._({
    required TopicDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'topicDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$topicDetailHash();

  @override
  String toString() {
    return r'topicDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TopicDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TopicDetail> create(Ref ref) {
    final argument = this.argument as String;
    return topicDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$topicDetailHash() => r'519e04795d0b70619410c29433424173c2575498';

/// Fetches detailed information for a specific topic.

final class TopicDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TopicDetail>, String> {
  TopicDetailFamily._()
    : super(
        retry: null,
        name: r'topicDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches detailed information for a specific topic.

  TopicDetailProvider call(String topicName) =>
      TopicDetailProvider._(argument: topicName, from: this);

  @override
  String toString() => r'topicDetailProvider';
}
