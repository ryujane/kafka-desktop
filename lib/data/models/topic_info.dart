class PartitionInfo {
  final int id;
  final int leader;
  final List<int> replicas;
  final List<int> isr;

  const PartitionInfo({
    required this.id,
    required this.leader,
    this.replicas = const [],
    this.isr = const [],
  });

  factory PartitionInfo.fromJson(Map<String, dynamic> json) => PartitionInfo(
    id: json['id'] as int,
    leader: json['leader'] as int,
    replicas: List<int>.from(json['replicas'] as List? ?? []),
    isr: List<int>.from(json['isr'] as List? ?? []),
  );
}

class TopicInfo {
  final String name;
  final List<PartitionInfo> partitions;
  final bool isInternal;

  const TopicInfo({
    required this.name,
    this.partitions = const [],
    this.isInternal = false,
  });

  factory TopicInfo.fromJson(Map<String, dynamic> json) => TopicInfo(
    name: json['name'] as String,
    partitions:
        (json['partitions'] as List?)
            ?.map((p) => PartitionInfo.fromJson(p as Map<String, dynamic>))
            .toList() ??
        [],
    isInternal: json['is_internal'] as bool? ?? false,
  );
}
