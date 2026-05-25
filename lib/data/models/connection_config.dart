import 'package:uuid/uuid.dart';

enum AuthType {
  none,
  saslPlain,
  saslScramSha256,
  saslScramSha512,
  saslGssapi,
  saslOauthbearer;

  String get label => switch (this) {
    none => 'None',
    saslPlain => 'SASL/PLAIN',
    saslScramSha256 => 'SASL/SCRAM-SHA-256',
    saslScramSha512 => 'SASL/SCRAM-SHA-512',
    saslGssapi => 'SASL/GSSAPI',
    saslOauthbearer => 'SASL/OAUTHBEARER',
  };
}

class AuthConfig {
  final AuthType type;
  final String username;
  final String password;

  const AuthConfig({
    required this.type,
    this.username = '',
    this.password = '',
  });

  factory AuthConfig.fromJson(Map<String, dynamic> json) => AuthConfig(
    type: AuthType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AuthType.none,
    ),
    username: json['username'] as String? ?? '',
    password: json['password'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'username': username,
    'password': password,
  };
}

class TlsConfig {
  final bool enabled;
  final String? caCertPath;
  final String? clientCertPath;
  final String? clientKeyPath;

  const TlsConfig({
    this.enabled = false,
    this.caCertPath,
    this.clientCertPath,
    this.clientKeyPath,
  });

  factory TlsConfig.fromJson(Map<String, dynamic> json) => TlsConfig(
    enabled: json['enabled'] as bool? ?? false,
    caCertPath: json['ca_cert_path'] as String?,
    clientCertPath: json['client_cert_path'] as String?,
    clientKeyPath: json['client_key_path'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    if (caCertPath != null) 'ca_cert_path': caCertPath,
    if (clientCertPath != null) 'client_cert_path': clientCertPath,
    if (clientKeyPath != null) 'client_key_path': clientKeyPath,
  };
}

class ConnectionConfig {
  final String id;
  final String name;
  final String brokers;
  final AuthConfig? auth;
  final TlsConfig? tls;
  final Map<String, String> properties;

  ConnectionConfig({
    String? id,
    required this.name,
    required this.brokers,
    this.auth,
    this.tls,
    this.properties = const {},
  }) : id = id ?? const Uuid().v4();

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) =>
      ConnectionConfig(
        id: json['id'] as String,
        name: json['name'] as String,
        brokers: json['brokers'] as String,
        auth: json['auth'] != null
            ? AuthConfig.fromJson(json['auth'] as Map<String, dynamic>)
            : null,
        tls: json['tls'] != null
            ? TlsConfig.fromJson(json['tls'] as Map<String, dynamic>)
            : null,
        properties: Map<String, String>.from(json['properties'] as Map? ?? {}),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'brokers': brokers,
    if (auth != null) 'auth': auth!.toJson(),
    if (tls != null) 'tls': tls!.toJson(),
    if (properties.isNotEmpty) 'properties': properties,
  };
}
