// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of application log entries from the FFI layer.
///
/// Converts raw [LogEvent] responses into [LogEntry] domain objects.

@ProviderFor(appLog)
final appLogProvider = AppLogProvider._();

/// Stream of application log entries from the FFI layer.
///
/// Converts raw [LogEvent] responses into [LogEntry] domain objects.

final class AppLogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LogEntry>>,
          List<LogEntry>,
          Stream<List<LogEntry>>
        >
    with $FutureModifier<List<LogEntry>>, $StreamProvider<List<LogEntry>> {
  /// Stream of application log entries from the FFI layer.
  ///
  /// Converts raw [LogEvent] responses into [LogEntry] domain objects.
  AppLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLogHash();

  @$internal
  @override
  $StreamProviderElement<List<LogEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LogEntry>> create(Ref ref) {
    return appLog(ref);
  }
}

String _$appLogHash() => r'058b7d31e08a401c704f722aa06fd8278646234d';
