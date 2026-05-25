import 'dart:ffi';
import 'dart:io';

/// Loads the librdkafka shared library appropriate for the current platform.
///
/// Resolves the platform-specific library path from the `third_party` directory
/// and opens it as a [DynamicLibrary].
DynamicLibrary loadLibRdKafka() {
  final libPath = _resolveLibPath();
  return DynamicLibrary.open(libPath);
}

String _resolveLibPath() {
  final base = _libDir;
  if (Platform.isLinux) return '$base/linux-x64/librdkafka.so';
  if (Platform.isMacOS) {
    return Platform.isArm64
        ? '$base/macos-arm64/librdkafka.dylib'
        : '$base/macos-x64/librdkafka.dylib';
  }
  if (Platform.isWindows) return '$base/windows-x64/librdkafka.dll';
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}

String get _libDir =>
    '${Directory.current.path}/lib/ffi/third_party/librdkafka';
