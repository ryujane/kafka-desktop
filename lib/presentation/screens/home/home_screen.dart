import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/data/models/connection_config.dart';
import 'package:kafkax/presentation/providers/connection_providers.dart';

/// Home screen showing KafkaX branding and saved connections.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final connectionsAsync = ref.watch(connectionListProvider);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Branding.
                Icon(
                  Icons.hub_outlined,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'KafkaX',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A full-featured Kafka desktop client.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 32),
                // Add Connection button.
                FilledButton.icon(
                  onPressed: () {
                    // TODO: Open add connection dialog.
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Connection'),
                ),
                const SizedBox(height: 24),
                // Saved connections list.
                connectionsAsync.when(
                  data: (connections) {
                    if (connections.isEmpty) {
                      return Text(
                        'No saved connections yet.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Saved Connections',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...connections.map(
                          (c) => _ConnectionTile(connection: c),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text(
                    'Error: $e',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A tile representing a saved connection.
class _ConnectionTile extends ConsumerWidget {
  const _ConnectionTile({required this.connection});

  final ConnectionConfig connection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeAsync = ref.watch(activeConnectionProvider);
    final isActive = activeAsync.value?.id == connection.id;

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.circle,
          size: 12,
          color: isActive ? Colors.green : Colors.grey,
        ),
        title: Text(connection.name),
        subtitle: Text(connection.brokers),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isActive)
              TextButton(
                onPressed: () async {
                  await ref
                      .read(activeConnectionProvider.notifier)
                      .connect(connection);
                  if (context.mounted) {
                    context.go('/cluster/${connection.id}');
                  }
                },
                child: const Text('Connect'),
              ),
            if (isActive)
              TextButton(
                onPressed: () async {
                  await ref
                      .read(activeConnectionProvider.notifier)
                      .disconnect();
                },
                child: const Text('Disconnect'),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              tooltip: 'Delete connection',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Connection'),
                    content: Text(
                      'Are you sure you want to delete "${connection.name}"?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await ref
                      .read(connectionListProvider.notifier)
                      .delete(connection.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
