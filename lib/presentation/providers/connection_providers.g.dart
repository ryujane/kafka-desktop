// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [SharedPreferences] singleton.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provides the [SharedPreferences] singleton.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Provides the [SharedPreferences] singleton.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'ad13470fe866595ad0f58a3e26f11048d94ef22e';

/// Provides the [ConnectionRepository] instance.

@ProviderFor(connectionRepository)
final connectionRepositoryProvider = ConnectionRepositoryProvider._();

/// Provides the [ConnectionRepository] instance.

final class ConnectionRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConnectionRepository>,
          ConnectionRepository,
          FutureOr<ConnectionRepository>
        >
    with
        $FutureModifier<ConnectionRepository>,
        $FutureProvider<ConnectionRepository> {
  /// Provides the [ConnectionRepository] instance.
  ConnectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<ConnectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConnectionRepository> create(Ref ref) {
    return connectionRepository(ref);
  }
}

String _$connectionRepositoryHash() =>
    r'0c1cff0dc8df7c9ac1ed3bd75c911200e186c85d';

/// Provides the [FfiIsolateManager] singleton.

@ProviderFor(ffiIsolateManager)
final ffiIsolateManagerProvider = FfiIsolateManagerProvider._();

/// Provides the [FfiIsolateManager] singleton.

final class FfiIsolateManagerProvider
    extends
        $FunctionalProvider<
          FfiIsolateManager,
          FfiIsolateManager,
          FfiIsolateManager
        >
    with $Provider<FfiIsolateManager> {
  /// Provides the [FfiIsolateManager] singleton.
  FfiIsolateManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ffiIsolateManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ffiIsolateManagerHash();

  @$internal
  @override
  $ProviderElement<FfiIsolateManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FfiIsolateManager create(Ref ref) {
    return ffiIsolateManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FfiIsolateManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FfiIsolateManager>(value),
    );
  }
}

String _$ffiIsolateManagerHash() => r'072268a300bf2ed24c1f91319fd8f7bb98870444';

/// Provides the [ConnectionManager] instance.

@ProviderFor(connectionManager)
final connectionManagerProvider = ConnectionManagerProvider._();

/// Provides the [ConnectionManager] instance.

final class ConnectionManagerProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConnectionManager>,
          ConnectionManager,
          FutureOr<ConnectionManager>
        >
    with
        $FutureModifier<ConnectionManager>,
        $FutureProvider<ConnectionManager> {
  /// Provides the [ConnectionManager] instance.
  ConnectionManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionManagerHash();

  @$internal
  @override
  $FutureProviderElement<ConnectionManager> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConnectionManager> create(Ref ref) {
    return connectionManager(ref);
  }
}

String _$connectionManagerHash() => r'd910775c304f0fddb5686f651ed2ee436b037673';

/// Manages the list of all saved connections.

@ProviderFor(ConnectionList)
final connectionListProvider = ConnectionListProvider._();

/// Manages the list of all saved connections.
final class ConnectionListProvider
    extends $AsyncNotifierProvider<ConnectionList, List<ConnectionConfig>> {
  /// Manages the list of all saved connections.
  ConnectionListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionListHash();

  @$internal
  @override
  ConnectionList create() => ConnectionList();
}

String _$connectionListHash() => r'49b6ef0a0fbd9fdc5cbafd284585dc0be3d548dd';

/// Manages the list of all saved connections.

abstract class _$ConnectionList extends $AsyncNotifier<List<ConnectionConfig>> {
  FutureOr<List<ConnectionConfig>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ConnectionConfig>>, List<ConnectionConfig>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ConnectionConfig>>,
                List<ConnectionConfig>
              >,
              AsyncValue<List<ConnectionConfig>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Manages the currently active (connected) connection.

@ProviderFor(ActiveConnection)
final activeConnectionProvider = ActiveConnectionProvider._();

/// Manages the currently active (connected) connection.
final class ActiveConnectionProvider
    extends $AsyncNotifierProvider<ActiveConnection, ConnectionConfig?> {
  /// Manages the currently active (connected) connection.
  ActiveConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeConnectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeConnectionHash();

  @$internal
  @override
  ActiveConnection create() => ActiveConnection();
}

String _$activeConnectionHash() => r'c623ee2627a1c8300f20355f4c6060e04e3e6f60';

/// Manages the currently active (connected) connection.

abstract class _$ActiveConnection extends $AsyncNotifier<ConnectionConfig?> {
  FutureOr<ConnectionConfig?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ConnectionConfig?>, ConnectionConfig?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ConnectionConfig?>, ConnectionConfig?>,
              AsyncValue<ConnectionConfig?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
