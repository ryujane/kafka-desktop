// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the current navigation target.

@ProviderFor(Navigation)
final navigationProvider = NavigationProvider._();

/// Manages the current navigation target.
final class NavigationProvider
    extends $NotifierProvider<Navigation, NavTarget> {
  /// Manages the current navigation target.
  NavigationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationHash();

  @$internal
  @override
  Navigation create() => Navigation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NavTarget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NavTarget>(value),
    );
  }
}

String _$navigationHash() => r'8ebcd4999a60220497886f62df72ed64b62b4789';

/// Manages the current navigation target.

abstract class _$Navigation extends $Notifier<NavTarget> {
  NavTarget build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NavTarget, NavTarget>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NavTarget, NavTarget>,
              NavTarget,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
