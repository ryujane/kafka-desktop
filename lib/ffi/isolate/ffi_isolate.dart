import 'dart:async';
import 'dart:isolate';

import 'ffi_messages.dart';

class FfiIsolateManager {
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  final _responseController = StreamController<FfiResponse>.broadcast();
  bool _running = false;

  Stream<FfiResponse> get responses => _responseController.stream;
  bool get isRunning => _running;

  Future<void> spawn() async {
    if (_running) return;

    final setupPort = ReceivePort();
    _isolate = await Isolate.spawn(_ffiIsolateEntry, setupPort.sendPort);

    _sendPort = await setupPort.first as SendPort;
    setupPort.close();

    _receivePort = ReceivePort();
    _sendPort!.send(_receivePort!.sendPort);

    _receivePort!.listen((message) {
      if (message is FfiResponse) {
        _responseController.add(message);
      }
    });

    _running = true;
  }

  Future<T> send<T extends FfiResponse>(FfiRequest request) async {
    if (!_running) throw StateError('FFI Isolate not running');
    _sendPort!.send(request);
    return _responseController.stream.firstWhere(
          (r) => r.connectionId == request.connectionId,
        )
        as T;
  }

  Future<void> shutdown() async {
    if (!_running) return;
    _sendPort?.send(ShutdownRequest());
    await _responseController.close();
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _running = false;
  }
}

void _ffiIsolateEntry(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);

  // Wait for the response SendPort from main isolate
  SendPort? responsePort;
  receivePort.listen((message) {
    if (message is SendPort && responsePort == null) {
      responsePort = message;
      return;
    }

    if (message is ShutdownRequest) {
      receivePort.close();
      Isolate.exit();
    }

    // FFI request handling will be implemented when connecting
    // to the actual wrapper classes
  });
}
