import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/data/models/connection_config.dart';
import 'package:kafkax/l10n/app_localizations.dart';
import 'package:kafkax/presentation/providers/connection_providers.dart';
import 'package:kafkax/presentation/providers/navigation_providers.dart';

const _kExpandedThreshold = 200.0;

/// Collapsible sidebar with connection selector and navigation links.
class Sidebar extends ConsumerWidget {
  const Sidebar({required this.onToggle, super.key});

  /// Callback when the collapse/expand toggle is pressed.
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expanded = constraints.maxWidth >= _kExpandedThreshold;
        final s = S.of(context)!;
        final connectionsAsync = ref.watch(connectionListProvider);
        final activeAsync = ref.watch(activeConnectionProvider);

        return Column(
          children: [
            _buildHeader(context, s, expanded),
            const Divider(height: 1),
            if (expanded) ...[
              _ConnectionSelector(
                connectionsAsync: connectionsAsync,
                activeAsync: activeAsync,
              ),
              const Divider(height: 1),
            ],
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (expanded)
                      _NavSection(
                        title: s.sidebarDevelopment,
                        items: [
                          _NavItem(
                            icon: Icons.topic_outlined,
                            label: s.sidebarTopics,
                            onTap: () =>
                                _navigateToTopics(ref, activeAsync),
                          ),
                          _NavItem(
                            icon: Icons.group_outlined,
                            label: s.sidebarGroups,
                            onTap: () =>
                                _navigateToGroups(ref, activeAsync),
                          ),
                          _NavItem(
                            icon: Icons.send_outlined,
                            label: s.sidebarProduce,
                            onTap: () =>
                                _navigateToProduce(ref, activeAsync),
                          ),
                        ],
                      ),
                    if (expanded)
                      _NavSection(
                        title: s.sidebarAdmin,
                        items: [
                          _NavItem(
                            icon: Icons.dns_outlined,
                            label: s.sidebarBrokers,
                            onTap: () =>
                                _navigateToCluster(ref, activeAsync),
                          ),
                        ],
                      ),
                    if (!expanded) ...[
                      const SizedBox(height: 8),
                      _IconNavItem(
                        icon: Icons.topic_outlined,
                        tooltip: s.sidebarTopics,
                        onTap: () =>
                            _navigateToTopics(ref, activeAsync),
                      ),
                      _IconNavItem(
                        icon: Icons.group_outlined,
                        tooltip: s.sidebarGroups,
                        onTap: () =>
                            _navigateToGroups(ref, activeAsync),
                      ),
                      _IconNavItem(
                        icon: Icons.send_outlined,
                        tooltip: s.sidebarProduce,
                        onTap: () =>
                            _navigateToProduce(ref, activeAsync),
                      ),
                      _IconNavItem(
                        icon: Icons.dns_outlined,
                        tooltip: s.sidebarBrokers,
                        onTap: () =>
                            _navigateToCluster(ref, activeAsync),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            _buildLogsButton(context, s, ref, expanded),
            _buildSettingsButton(context, s, ref, expanded),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, S s, bool expanded) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: expanded ? 8 : 4),
        child: Row(
          children: [
            IconButton(
              icon: Icon(expanded ? Icons.menu_open : Icons.menu),
              onPressed: onToggle,
              tooltip: expanded ? 'Collapse sidebar' : 'Expand sidebar',
            ),
            if (expanded) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.appName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogsButton(
    BuildContext context,
    S s,
    WidgetRef ref,
    bool expanded,
  ) {
    final nav = ref.read(navigationProvider.notifier);
    if (expanded) {
      return ListTile(
        leading: const Icon(Icons.article_outlined),
        title: Text(s.sidebarLogs),
        dense: true,
        onTap: () => nav.go(const NavLogs()),
      );
    }
    return Tooltip(
      message: s.sidebarLogs,
      child: IconButton(
        icon: const Icon(Icons.article_outlined),
        onPressed: () => nav.go(const NavLogs()),
      ),
    );
  }

  Widget _buildSettingsButton(
    BuildContext context,
    S s,
    WidgetRef ref,
    bool expanded,
  ) {
    final nav = ref.read(navigationProvider.notifier);
    if (expanded) {
      return ListTile(
        leading: const Icon(Icons.settings_outlined),
        title: Text(s.sidebarSettings),
        dense: true,
        onTap: () => nav.go(const NavSettings()),
      );
    }
    return Tooltip(
      message: s.sidebarSettings,
      child: IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => nav.go(const NavSettings()),
      ),
    );
  }

  void _navigateToTopics(WidgetRef ref, AsyncValue<ConnectionConfig?> active) {
    final id = active.value?.id;
    if (id != null) {
      ref.read(navigationProvider.notifier).go(NavTopics(clusterId: id));
    }
  }

  void _navigateToGroups(WidgetRef ref, AsyncValue<ConnectionConfig?> active) {
    final id = active.value?.id;
    if (id != null) {
      ref.read(navigationProvider.notifier).go(NavGroups(clusterId: id));
    }
  }

  void _navigateToProduce(WidgetRef ref, AsyncValue<ConnectionConfig?> active) {
    final id = active.value?.id;
    if (id != null) {
      ref.read(navigationProvider.notifier).go(NavProduce(clusterId: id));
    }
  }

  void _navigateToCluster(WidgetRef ref, AsyncValue<ConnectionConfig?> active) {
    final id = active.value?.id;
    if (id != null) {
      ref.read(navigationProvider.notifier).go(NavCluster(clusterId: id));
    }
  }
}

/// Dropdown to select and connect to a saved connection.
class _ConnectionSelector extends ConsumerWidget {
  const _ConnectionSelector({
    required this.connectionsAsync,
    required this.activeAsync,
  });

  final AsyncValue<List<ConnectionConfig>> connectionsAsync;
  final AsyncValue<ConnectionConfig?> activeAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final active = activeAsync.value;
    final theme = Theme.of(context);

    return connectionsAsync.when(
      data: (connections) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: DropdownButton<String>(
            value: active?.id,
            hint: Text(s.sidebarSelectCluster),
            isExpanded: true,
            underline: const SizedBox.shrink(),
            items: [
              ...connections.map(
                (c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name, overflow: TextOverflow.ellipsis),
                ),
              ),
              DropdownMenuItem(
                value: '__add__',
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 16),
                    const SizedBox(width: 8),
                    Text(s.homeAddConnection),
                  ],
                ),
              ),
            ],
            onChanged: (value) async {
              if (value == null) return;
              if (value == '__add__') {
                // TODO: Navigate to add connection dialog/screen.
                return;
              }
              if (active?.id == value) return;
              if (active != null) {
                await ref.read(activeConnectionProvider.notifier).disconnect();
              }
              final config = connections.firstWhere((c) => c.id == value);
              await ref.read(activeConnectionProvider.notifier).connect(config);
            },
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(12),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          '${s.error}: $e',
          style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
        ),
      ),
    );
  }
}

/// A section of navigation items with a header label.
class _NavSection extends StatelessWidget {
  const _NavSection({required this.title, required this.items});

  final String title;
  final List<_NavItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}

/// A single navigation item with icon and label.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label),
      dense: true,
      onTap: onTap,
    );
  }
}

/// A compact icon-only navigation item for collapsed sidebar.
class _IconNavItem extends StatelessWidget {
  const _IconNavItem({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(icon: Icon(icon, size: 20), onPressed: onTap),
    );
  }
}
