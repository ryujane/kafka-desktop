import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kafkax/data/models/log_entry.dart';
import 'package:kafkax/ffi/isolate/ffi_messages.dart';
import 'connection_providers.dart';

part 'log_providers.g.dart';

/// Stream of application log entries from the FFI layer.
///
/// Converts raw [LogEvent] responses into [LogEntry] domain objects.
@Riverpod(keepAlive: true)
Stream<List<LogEntry>> appLog(Ref ref) {
  final isolateManager = ref.watch(ffiIsolateManagerProvider);
  final logs = <LogEntry>[];

  final controller = StreamController<List<LogEntry>>();
  controller.add(List.unmodifiable(logs));

  final sub = isolateManager.responses
      .where((r) => r is LogEvent)
      .cast<LogEvent>()
      .listen((event) {
        logs.add(
          LogEntry(
            timestamp: DateTime.now(),
            level: _parseLevel(event.level),
            connectionId: event.connectionId,
            message: event.message,
            metadata: event.metadata,
          ),
        );
        if (!controller.isClosed) {
          controller.add(List.unmodifiable(logs));
        }
      });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
}

LogLevel _parseLevel(String level) => switch (level.toLowerCase()) {
  'debug' => LogLevel.debug,
  'info' => LogLevel.info,
  'warn' => LogLevel.warn,
  'error' => LogLevel.error,
  _ => LogLevel.info,
};
