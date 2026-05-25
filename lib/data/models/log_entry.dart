enum LogLevel {
  debug,
  info,
  warn,
  error;

  String get label => name.toUpperCase();
}

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String connectionId;
  final String message;
  final Map<String, dynamic>? metadata;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.connectionId,
    required this.message,
    this.metadata,
  });
}
