class BrokerInfo {
  final int id;
  final String host;
  final int port;
  final String? rack;

  const BrokerInfo({
    required this.id,
    required this.host,
    required this.port,
    this.rack,
  });

  String get address => '$host:$port';
}
