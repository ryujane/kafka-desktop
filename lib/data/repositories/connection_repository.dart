import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/connection_config.dart';

/// CRUD operations for [ConnectionConfig] persisted in SharedPreferences.
class ConnectionRepository {
  static const _connectionsKey = 'kafkax_connections';

  final SharedPreferences _prefs;

  ConnectionRepository(this._prefs);

  /// Returns all saved connections.
  Future<List<ConnectionConfig>> loadAll() async {
    final raw = _prefs.getString(_connectionsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((j) => ConnectionConfig.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Inserts or updates [config] (matched by [ConnectionConfig.id]).
  Future<void> save(ConnectionConfig config) async {
    final all = await loadAll();
    final idx = all.indexWhere((c) => c.id == config.id);
    if (idx >= 0) {
      all[idx] = config;
    } else {
      all.add(config);
    }
    await _persist(all);
  }

  /// Removes the connection with the given [id].
  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((c) => c.id == id);
    await _persist(all);
  }

  Future<void> _persist(List<ConnectionConfig> connections) async {
    final json = jsonEncode(connections.map((c) => c.toJson()).toList());
    await _prefs.setString(_connectionsKey, json);
  }
}
