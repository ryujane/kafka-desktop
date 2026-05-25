import 'dart:ffi';
import 'dart:io';

/// Loads the librdkafka shared library appropriate for the current platform.
///
/// This is a fallback utility for cases where the `@Native` bindings (which
/// resolve symbols automatically via native assets) cannot be used. The
/// generated bindings at `bindings/rd_kafka.dart` use `@ffi.Native` annotations
/// with `@ffi.DefaultAsset('package:kafkax/kafkax_ffi.dart')` and do not
/// require manual [DynamicLibrary] loading under normal circumstances.
DynamicLibrary loadLibRdKafka() {
  final libPath = _resolveLibPath();
  return DynamicLibrary.open(libPath);
}

String _resolveLibPath() {
  final base = _libDir;
  if (Platform.isLinux) {
    return '$base/linux-x64/native/librdkafka.so';
  }
  if (Platform.isMacOS) {
    return '$base/osx-arm64/native/librdkafka.dylib';
  }
  if (Platform.isWindows) {
    return '$base/win-x64/native/librdkafka.dll';
  }
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}

String get _libDir => '${Directory.current.path}/third_party/librdkafka/lib';
