import 'package:flutter/material.dart';

import 'package:kafkax/l10n/app_localizations.dart';

/// Cluster overview screen showing broker information.
class ClusterScreen extends StatelessWidget {
  const ClusterScreen({required this.clusterId, super.key});

  /// The cluster (connection) identifier.
  final String clusterId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.clusterOverview)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dns_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '${s.clusterOverview}: $clusterId',
              style: theme.textTheme.titleLarge,
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
      ),
    );
  }
}
