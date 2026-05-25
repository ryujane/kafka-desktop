import 'package:go_router/go_router.dart';

import 'package:kafkax/presentation/widgets/app_shell.dart';
import 'package:kafkax/presentation/screens/home/home_screen.dart';
import 'package:kafkax/presentation/screens/cluster/cluster_screen.dart';
import 'package:kafkax/presentation/screens/topic/topic_list_screen.dart';
import 'package:kafkax/presentation/screens/topic/topic_detail_screen.dart';
import 'package:kafkax/presentation/screens/producer/producer_screen.dart';
import 'package:kafkax/presentation/screens/consumer_group/group_list_screen.dart';
import 'package:kafkax/presentation/screens/consumer_group/group_detail_screen.dart';
import 'package:kafkax/presentation/screens/settings/settings_screen.dart';

/// Global [GoRouter] instance for the application.
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: <RouteBase>[
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/cluster/:id',
          builder: (context, state) {
            final clusterId = state.pathParameters['id']!;
            return ClusterScreen(clusterId: clusterId);
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'topics',
              builder: (context, state) {
                final clusterId = state.pathParameters['id']!;
                return TopicListScreen(clusterId: clusterId);
              },
            ),
            GoRoute(
              path: 'topics/:name',
              builder: (context, state) {
                final clusterId = state.pathParameters['id']!;
                final topicName = state.pathParameters['name']!;
                return TopicDetailScreen(
                  clusterId: clusterId,
                  topicName: topicName,
                );
              },
            ),
            GoRoute(
              path: 'produce',
              builder: (context, state) {
                final clusterId = state.pathParameters['id']!;
                return ProducerScreen(clusterId: clusterId);
              },
            ),
            GoRoute(
              path: 'groups',
              builder: (context, state) {
                final clusterId = state.pathParameters['id']!;
                return GroupListScreen(clusterId: clusterId);
              },
            ),
            GoRoute(
              path: 'groups/:gid',
              builder: (context, state) {
                final clusterId = state.pathParameters['id']!;
                final groupId = state.pathParameters['gid']!;
                return GroupDetailScreen(
                  clusterId: clusterId,
                  groupId: groupId,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
