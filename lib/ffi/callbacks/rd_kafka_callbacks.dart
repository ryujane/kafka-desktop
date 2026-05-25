import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

/// Manages native callbacks for librdkafka events.
///
/// Provides [NativeCallable.listener] instances for log, stats, and delivery
/// report callbacks. These are designed to be used within an isolate, with
/// events forwarded via a [SendPort].
class KafkaCallbacks {
  final SendPort _sendPort;

  late final NativeCallable<
    Void Function(Pointer, Int32, Pointer<Utf8>, Pointer<Utf8>)
  >
  logCallback;

  late final NativeCallable<
    Void Function(Pointer, Int32, Pointer<Utf8>, Pointer<Utf8>, Int64)
  >
  statsCallback;

  late final NativeCallable<Void Function(Pointer, Pointer, Pointer)>
  deliveryReportCallback;

  KafkaCallbacks(this._sendPort) {
    logCallback =
        NativeCallable<
          Void Function(Pointer, Int32, Pointer<Utf8>, Pointer<Utf8>)
        >.listener(_handleLog);

    statsCallback =
        NativeCallable<
          Void Function(Pointer, Int32, Pointer<Utf8>, Pointer<Utf8>, Int64)
        >.listener(_handleStats);

    deliveryReportCallback =
        NativeCallable<Void Function(Pointer, Pointer, Pointer)>.listener(
          _handleDeliveryReport,
        );
  }

  void _handleLog(Pointer rk, int level, Pointer<Utf8> fac, Pointer<Utf8> buf) {
    // ignore: unused_element
    _sendPort; // Will be used in isolate implementation
  }

  void _handleStats(
    Pointer rk,
    int level,
    Pointer<Utf8> fac,
    Pointer<Utf8> buf,
    int ts,
  ) {
    _sendPort; // Will be used in isolate implementation
  }

  void _handleDeliveryReport(Pointer rk, Pointer msg, Pointer opaque) {
    _sendPort; // Will be used in isolate implementation
  }

  /// Closes all native callables. Must be called when done to prevent leaks.
  void dispose() {
    logCallback.close();
    statsCallback.close();
    deliveryReportCallback.close();
  }
}
