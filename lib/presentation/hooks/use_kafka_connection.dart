import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/data/models/connection_config.dart';
import 'package:kafkax/presentation/providers/connection_providers.dart';

/// Hook that provides easy access to the active connection state.
///
/// Returns an [AsyncValue] containing the currently active [ConnectionConfig],
/// or `null` if no connection is active.
AsyncValue<ConnectionConfig?> useActiveConnection(WidgetRef ref) {
  return ref.watch(activeConnectionProvider);
}
