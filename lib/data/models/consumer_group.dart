class GroupMember {
  final String memberId;
  final String clientId;
  final String clientHost;
  final List<int> assignments;

  const GroupMember({
    required this.memberId,
    required this.clientId,
    required this.clientHost,
    this.assignments = const [],
  });
}

class ConsumerGroup {
  final String groupId;
  final String state;
  final List<GroupMember> members;
  final String protocolType;

  const ConsumerGroup({
    required this.groupId,
    required this.state,
    this.members = const [],
    this.protocolType = 'consumer',
  });

  int get memberCount => members.length;
}
