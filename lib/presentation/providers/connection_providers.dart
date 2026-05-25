import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kafkax/data/models/connection_config.dart';
import 'package:kafkax/data/repositories/connection_repository.dart';
import 'package:kafkax/domain/connection_manager.dart';
import 'package:kafkax/ffi/isolate/ffi_isolate.dart';

part 'connection_providers.g.dart';

/// Provides the [SharedPreferences] singleton.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) =>
    SharedPreferences.getInstance();

/// Provides the [ConnectionRepository] instance.
@Riverpod(keepAlive: true)
ConnectionRepository connectionRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return ConnectionRepository(prefs);
}

/// Provides the [FfiIsolateManager] singleton.
@Riverpod(keepAlive: true)
FfiIsolateManager ffiIsolateManager(Ref ref) => FfiIsolateManager();

/// Provides the [ConnectionManager] instance.
@Riverpod(keepAlive: true)
ConnectionManager connectionManager(Ref ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  final isolateManager = ref.watch(ffiIsolateManagerProvider);
  final manager = ConnectionManager(
    repository: repository,
    isolateManager: isolateManager,
  );
  ref.onDispose(() => manager.dispose());
  return manager;
}

/// Manages the list of all saved connections.
@Riverpod(keepAlive: true)
class ConnectionList extends _$ConnectionList {
  @override
  Future<List<ConnectionConfig>> build() =>
      ref.watch(connectionManagerProvider).loadAll();

  /// Saves (inserts or updates) a connection config and refreshes the list.
  Future<void> save(ConnectionConfig config) async {
    await ref.read(connectionManagerProvider).save(config);
    ref.invalidateSelf();
  }

  /// Deletes a connection by [id] and refreshes the list.
  Future<void> delete(String id) async {
    await ref.read(connectionManagerProvider).delete(id);
    ref.invalidateSelf();
  }
}

/// Manages the currently active (connected) connection.
@riverpod
class ActiveConnection extends _$ActiveConnection {
  StreamSubscription<String>? _subscription;

  @override
  Future<ConnectionConfig?> build() async {
    final manager = ref.watch(connectionManagerProvider);
    _subscription?.cancel();
    _subscription = manager.onActiveChanged.listen((_) {
      ref.invalidateSelf();
    });
    ref.onDispose(() => _subscription?.cancel());
    return null;
  }

  /// Connects to the cluster described by [config].
  Future<void> connect(ConnectionConfig config) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(connectionManagerProvider).connect(config);
      return config;
    });
  }

  /// Disconnects the current active connection.
  Future<void> disconnect() async {
    final current = state.value;
    if (current == null) return;
    await ref.read(connectionManagerProvider).disconnect(current.id);
    state = const AsyncData(null);
  }
}
