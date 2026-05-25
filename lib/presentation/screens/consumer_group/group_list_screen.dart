import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/l10n/app_localizations.dart';
import 'package:kafkax/presentation/providers/consumer_group_providers.dart';

/// Screen listing all consumer groups for a given cluster.
class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({required this.clusterId, super.key});

  /// The cluster (connection) identifier.
  final String clusterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    final groupsAsync = ref.watch(groupListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.groupList),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(groupListProvider),
            tooltip: 'Refresh groups',
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group_outlined,
                    size: 48,
                    color: theme.disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(s.noData, style: theme.textTheme.bodyLarge),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                leading: const Icon(Icons.group_outlined),
                title: Text(group.groupId),
                subtitle: Text(
                  '${s.groupState}: ${group.state}  |  '
                  '${s.groupMemberCount}: ${group.members.length}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.go('/cluster/$clusterId/groups/${group.groupId}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${s.error}: $e')),
      ),
    );
  }
}
