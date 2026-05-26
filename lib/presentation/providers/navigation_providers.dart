import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_providers.g.dart';

/// Sealed type representing every navigable destination in the app.
sealed class NavTarget {
  const NavTarget();
}

class NavHome extends NavTarget {
  const NavHome();
}

class NavCluster extends NavTarget {
  const NavCluster({required this.clusterId});
  final String clusterId;
}

class NavTopics extends NavTarget {
  const NavTopics({required this.clusterId});
  final String clusterId;
}

class NavTopicDetail extends NavTarget {
  const NavTopicDetail({
    required this.clusterId,
    required this.topicName,
  });
  final String clusterId;
  final String topicName;
}

class NavProduce extends NavTarget {
  const NavProduce({required this.clusterId});
  final String clusterId;
}

class NavGroups extends NavTarget {
  const NavGroups({required this.clusterId});
  final String clusterId;
}

class NavGroupDetail extends NavTarget {
  const NavGroupDetail({
    required this.clusterId,
    required this.groupId,
  });
  final String clusterId;
  final String groupId;
}

class NavLogs extends NavTarget {
  const NavLogs();
}

class NavSettings extends NavTarget {
  const NavSettings();
}

/// Manages the current navigation target.
@Riverpod(keepAlive: true)
class Navigation extends _$Navigation {
  @override
  NavTarget build() => const NavHome();

  void go(NavTarget target) => state = target;
}
