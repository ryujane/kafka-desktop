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
        'Place pre-compiled libraries in third_party/librdkafka/lib/.',
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
    OS.linux => switch (arch) {
      Architecture.arm64 => 'linux-arm64',
      _ => 'linux-x64',
    },
    OS.macOS => switch (arch) {
      Architecture.arm64 => 'osx-arm64',
      _ => 'osx-x64',
    },
    OS.windows => switch (arch) {
      Architecture.x64 => 'win-x64',
      _ => 'win-x86',
    },
    _ => throw UnsupportedError('Unsupported OS: $os'),
  };

  final libName = os.dylibFileName('rdkafka');
  return packageRoot.resolve(
    'third_party/librdkafka/lib/$platformDir/native/$libName',
  );
}
