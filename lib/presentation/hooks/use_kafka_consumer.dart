import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:kafkax/data/models/kafka_message.dart';
import 'package:kafkax/ffi/lib/src/isolate/ffi_isolate.dart';
import 'package:kafkax/ffi/lib/src/isolate/ffi_messages.dart';

/// Hook that manages a Kafka consumer subscription lifecycle.
///
/// Subscribes to [MessageEvent] responses from the [FfiIsolateManager] for the
/// given [connectionId], converting raw message maps into [KafkaMessage]
/// instances and forwarding them through a local [StreamController].
///
/// Returns a [Stream<List<KafkaMessage>>] that emits batches of consumed
/// messages. The subscription is automatically cancelled when the widget is
/// disposed or when the [connectionId] changes.
Stream<List<KafkaMessage>> useKafkaConsumer(
  FfiIsolateManager isolate,
  String connectionId,
) {
  final controller = useMemoized(
    () => StreamController<List<KafkaMessage>>.broadcast(),
    [connectionId],
  );

  useEffect(() {
    final sub = isolate.responses
        .where((e) => e is MessageEvent)
        .cast<MessageEvent>()
        .where((e) => e.connectionId == connectionId)
        .listen((event) {
          final messages = event.messages.map((map) {
            return KafkaMessage(
              offset: map['offset'] as int,
              partition: map['partition'] as int,
              key: map['key'] as String?,
              value: (map['value'] as List<dynamic>).cast<int>(),
              timestamp: map['timestamp'] as DateTime,
              headers:
                  (map['headers'] as Map<String, dynamic>?)?.map(
                    (k, v) => MapEntry(k, (v as List<dynamic>).cast<int>()),
                  ) ??
                  {},
            );
          }).toList();

          if (!controller.isClosed) {
            controller.add(messages);
          }
        });

    return () {
      sub.cancel();
      controller.close();
    };
  }, [isolate, connectionId]);

  return controller.stream;
}
