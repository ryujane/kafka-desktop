import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/data/models/log_entry.dart';
import 'package:kafkax/ffi/isolate/ffi_messages.dart';
import 'connection_providers.dart';

part 'log_providers.g.dart';

/// Stream of application log entries from the FFI layer.
///
/// Converts raw [LogEvent] responses into [LogEntry] domain objects.
@Riverpod(keepAlive: true)
Stream<List<LogEntry>> appLog(Ref ref) async* {
  final isolateManager = ref.watch(ffiIsolateManagerProvider);
  final logs = <LogEntry>[];

  yield List.unmodifiable(logs);

  await for (final response in isolateManager.responses) {
    if (response is LogEvent) {
      logs.add(
        LogEntry(
          timestamp: DateTime.now(),
          level: _parseLevel(response.level),
          connectionId: response.connectionId,
          message: response.message,
          metadata: response.metadata,
        ),
      );
      yield List.unmodifiable(logs);
    }
  }
}

LogLevel _parseLevel(String level) => switch (level.toLowerCase()) {
  'debug' => LogLevel.debug,
  'info' => LogLevel.info,
  'warn' => LogLevel.warn,
  'error' => LogLevel.error,
  _ => LogLevel.info,
};
