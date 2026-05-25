import 'dart:async';

import 'package:kafkax/data/models/connection_config.dart';
import 'package:kafkax/data/repositories/connection_repository.dart';
import 'package:kafkax/ffi/isolate/ffi_isolate.dart';
import 'package:kafkax/ffi/isolate/ffi_messages.dart';

/// Manages multiple Kafka connection lifecycles.
///
/// Provides CRUD for [ConnectionConfig] via [ConnectionRepository] and
/// connect/disconnect operations via [FfiIsolateManager].
class ConnectionManager {
  /// Connection IDs that are currently active (connected).
  final _activeConnections = <String>{};

  /// Stream controller that emits connection ID changes.
  final _activeController = StreamController<String>.broadcast();

  final ConnectionRepository _repository;
  final FfiIsolateManager _isolateManager;

  ConnectionManager({required this._repository, required this._isolateManager});

  /// Stream of connection IDs that become active or inactive.
  Stream<String> get onActiveChanged => _activeController.stream;

  /// The set of currently active connection IDs.
  Set<String> get activeConnectionIds => Set.unmodifiable(_activeConnections);

  /// Whether [connectionId] is currently connected.
  bool isActive(String connectionId) =>
      _activeConnections.contains(connectionId);

  // ---------------------------------------------------------------------------
  // Persistence (delegates to ConnectionRepository)
  // ---------------------------------------------------------------------------

  /// Loads all saved connections from persistent storage.
  Future<List<ConnectionConfig>> loadAll() => _repository.loadAll();

  /// Saves (inserts or updates) a [ConnectionConfig].
  Future<void> save(ConnectionConfig config) => _repository.save(config);

  /// Deletes a saved connection. Disconnects first if active.
  Future<void> delete(String connectionId) async {
    if (isActive(connectionId)) {
      await disconnect(connectionId);
    }
    await _repository.delete(connectionId);
  }

  // ---------------------------------------------------------------------------
  // Connect / Disconnect
  // ---------------------------------------------------------------------------

  /// Opens a Kafka connection for the given [config].
  ///
  /// Sends a [ConnectRequest] through the FFI isolate and, on success, tracks
  /// the connection as active.
  ///
  /// Throws [ConnectionException] on failure.
  Future<void> connect(ConnectionConfig config) async {
    if (!_isolateManager.isRunning) {
      await _isolateManager.spawn();
    }

    final response = await _isolateManager.send<ConnectResponse>(
      ConnectRequest(
        connectionId: config.id,
        brokers: config.brokers,
        authType: config.auth?.type.name,
        username: config.auth?.username,
        password: config.auth?.password,
        tlsEnabled: config.tls?.enabled ?? false,
        caCertPath: config.tls?.caCertPath,
        properties: config.properties,
      ),
    );

    if (!response.success) {
      throw ConnectionException(
        connectionId: config.id,
        message: response.error ?? 'Unknown connection error',
      );
    }

    _activeConnections.add(config.id);
    _activeController.add(config.id);
  }

  /// Closes the Kafka connection identified by [connectionId].
  ///
  /// Sends a [DisconnectRequest] and removes the connection from the active
  /// set regardless of the response (best-effort disconnect).
  Future<void> disconnect(String connectionId) async {
    if (!isActive(connectionId)) return;

    await _isolateManager.send<DisconnectResponse>(
      DisconnectRequest(connectionId),
    );

    _activeConnections.remove(connectionId);
    _activeController.add(connectionId);
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  /// Disconnects all active connections and stops the isolate.
  Future<void> dispose() async {
    for (final id in _activeConnections.toList()) {
      await disconnect(id);
    }
    await _activeController.close();
  }
}

/// Exception thrown when a connection operation fails.
class ConnectionException implements Exception {
  final String connectionId;
  final String message;

  const ConnectionException({
    required this.connectionId,
    required this.message,
  });

  @override
  String toString() => 'ConnectionException($connectionId): $message';
}
