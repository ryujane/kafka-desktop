import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/core/theme/theme_extension.dart';
import 'package:kafkax/presentation/providers/navigation_providers.dart';
import 'package:kafkax/presentation/screens/cluster/cluster_screen.dart';
import 'package:kafkax/presentation/screens/consumer_group/group_detail_screen.dart';
import 'package:kafkax/presentation/screens/consumer_group/group_list_screen.dart';
import 'package:kafkax/presentation/screens/home/home_screen.dart';
import 'package:kafkax/presentation/screens/log/log_screen.dart';
import 'package:kafkax/presentation/screens/producer/producer_screen.dart';
import 'package:kafkax/presentation/screens/settings/settings_screen.dart';
import 'package:kafkax/presentation/screens/topic/topic_detail_screen.dart';
import 'package:kafkax/presentation/screens/topic/topic_list_screen.dart';
import 'package:kafkax/presentation/widgets/sidebar.dart';
import 'package:kafkax/presentation/widgets/status_bar.dart';

/// Main application shell containing sidebar, content area, and status bar.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _sidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KafkaXColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final target = ref.watch(navigationProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: _sidebarExpanded ? 240 : 56,
                  decoration: BoxDecoration(
                    color:
                        colors.sidebarBackground ??
                        (isDark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFFF5F5F5)),
                    border: Border(
                      right: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Sidebar(
                      onToggle: () {
                        setState(() {
                          _sidebarExpanded = !_sidebarExpanded;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(child: _buildContent(target)),
              ],
            ),
          ),
          const StatusBar(),
        ],
      ),
    );
  }

  Widget _buildContent(NavTarget target) => switch (target) {
    NavHome() => const HomeScreen(),
    NavCluster(:final clusterId) => ClusterScreen(clusterId: clusterId),
    NavTopics(:final clusterId) => TopicListScreen(clusterId: clusterId),
    NavTopicDetail(:final clusterId, :final topicName) => TopicDetailScreen(
      clusterId: clusterId,
      topicName: topicName,
    ),
    NavProduce(:final clusterId) => ProducerScreen(clusterId: clusterId),
    NavGroups(:final clusterId) => GroupListScreen(clusterId: clusterId),
    NavGroupDetail(:final clusterId, :final groupId) => GroupDetailScreen(
      clusterId: clusterId,
      groupId: groupId,
    ),
    NavLogs() => const LogScreen(),
    NavSettings() => const SettingsScreen(),
  };
}
