import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:kafkax/ffi/lib/src/isolate/ffi_isolate.dart';
import 'package:kafkax/ffi/lib/src/isolate/ffi_messages.dart';

/// Hook that listens to a specific response type [T] from the FFI isolate.
///
/// Automatically subscribes to [FfiIsolateManager.responses] and filters by
/// type [T]. The subscription is cancelled when the widget is disposed or when
/// the [isolate] instance changes.
void useIsolateMessage<T extends FfiResponse>(
  FfiIsolateManager isolate,
  void Function(T) onMessage,
) {
  useEffect(() {
    final sub = isolate.responses.whereType<T>().listen(onMessage);
    return sub.cancel;
  }, [isolate]);
}
