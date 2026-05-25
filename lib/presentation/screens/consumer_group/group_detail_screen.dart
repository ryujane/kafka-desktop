import 'package:flutter/material.dart';

import 'package:kafkax/l10n/app_localizations.dart';

/// Detailed view of a consumer group with Members, Lag, and Offsets tabs.
class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({
    required this.clusterId,
    required this.groupId,
    super.key,
  });

  /// The cluster (connection) identifier.
  final String clusterId;

  /// The consumer group identifier.
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(groupId),
          bottom: TabBar(
            tabs: [
              Tab(text: s.groupMembers),
              Tab(text: s.groupLag),
              Tab(text: s.groupOffsets),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MembersTabPlaceholder(groupId: groupId),
            _LagTabPlaceholder(),
            _OffsetsTabPlaceholder(),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the Members tab.
class _MembersTabPlaceholder extends StatelessWidget {
  const _MembersTabPlaceholder({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(
            '${s.groupMembers}: $groupId',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            s.noData,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder for the Lag tab.
class _LagTabPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timeline, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(s.groupLag, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            s.noData,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder for the Offsets tab.
class _OffsetsTabPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_outline, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(s.groupOffsets, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            s.noData,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
