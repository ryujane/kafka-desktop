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
Future<ConnectionRepository> connectionRepository(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ConnectionRepository(prefs);
}

/// Provides the [FfiIsolateManager] singleton.
@Riverpod(keepAlive: true)
FfiIsolateManager ffiIsolateManager(Ref ref) => FfiIsolateManager();

/// Provides the [ConnectionManager] instance.
@Riverpod(keepAlive: true)
Future<ConnectionManager> connectionManager(Ref ref) async {
  final repository = await ref.watch(connectionRepositoryProvider.future);
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
  Future<List<ConnectionConfig>> build() async {
    final manager = await ref.watch(connectionManagerProvider.future);
    return manager.loadAll();
  }

  /// Saves (inserts or updates) a connection config and refreshes the list.
  Future<void> save(ConnectionConfig config) async {
    final manager = await ref.read(connectionManagerProvider.future);
    await manager.save(config);
    ref.invalidateSelf();
  }

  /// Deletes a connection by [id] and refreshes the list.
  Future<void> delete(String id) async {
    final manager = await ref.read(connectionManagerProvider.future);
    await manager.delete(id);
    ref.invalidateSelf();
  }
}

/// Manages the currently active (connected) connection.
@riverpod
class ActiveConnection extends _$ActiveConnection {
  StreamSubscription<String>? _subscription;

  @override
  Future<ConnectionConfig?> build() async {
    final manager = await ref.watch(connectionManagerProvider.future);
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
      final manager = await ref.read(connectionManagerProvider.future);
      await manager.connect(config);
      return config;
    });
  }

  /// Disconnects the current active connection.
  Future<void> disconnect() async {
    final current = state.value;
    if (current == null) return;
    final manager = await ref.read(connectionManagerProvider.future);
    await manager.disconnect(current.id);
    state = const AsyncData(null);
  }
}
