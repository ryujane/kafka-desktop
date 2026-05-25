import 'dart:io';

import 'package:native_assets_cli/code_assets.dart';
import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final packageName = input.packageName;
    final packageRoot = input.packageRoot;
    final targetOS = input.config.code.targetOS;
    final targetArch = input.config.code.targetArchitecture;

    final libPath = _resolveLibPath(packageRoot, targetOS, targetArch);

    final libFile = File.fromUri(libPath);
    if (!libFile.existsSync()) {
      throw StateError(
        'librdkafka library not found at ${libFile.path}. '
        'Place pre-compiled libraries in lib/ffi/third_party/librdkafka/.',
      );
    }

    output.assets.code.add(
      CodeAsset(
        package: packageName,
        name: 'kafkax_ffi.dart',
        linkMode: DynamicLoadingBundled(),
        file: libPath,
      ),
    );

    output.addDependencies([libPath]);
  });
}

Uri _resolveLibPath(Uri packageRoot, OS os, Architecture arch) {
  final platformDir = switch (os) {
    OS.linux => 'linux-x64',
    OS.macOS => switch (arch) {
      Architecture.arm64 => 'macos-arm64',
      _ => 'macos-x64',
    },
    OS.windows => 'windows-x64',
    _ => throw UnsupportedError('Unsupported OS: $os'),
  };

  final libName = os.dylibFileName('rdkafka');
  return packageRoot.resolve(
    'lib/ffi/third_party/librdkafka/$platformDir/$libName',
  );
}
