sealed class FfiRequest {
  final String connectionId;
  FfiRequest(this.connectionId);
}

class ConnectRequest extends FfiRequest {
  final String brokers;
  final String? authType;
  final String? username;
  final String? password;
  final bool tlsEnabled;
  final String? caCertPath;
  final Map<String, String> properties;

  ConnectRequest({
    required super.connectionId,
    required this.brokers,
    this.authType,
    this.username,
    this.password,
    this.tlsEnabled = false,
    this.caCertPath,
    this.properties = const {},
  });
}

class DisconnectRequest extends FfiRequest {
  DisconnectRequest(super.connectionId);
}

class ListTopicsRequest extends FfiRequest {
  ListTopicsRequest(super.connectionId);
}

class CreateTopicRequest extends FfiRequest {
  final String name;
  final int partitions;
  final int replicationFactor;
  final Map<String, String> config;

  CreateTopicRequest({
    required super.connectionId,
    required this.name,
    required this.partitions,
    required this.replicationFactor,
    this.config = const {},
  });
}

class DeleteTopicRequest extends FfiRequest {
  final String topicName;
  DeleteTopicRequest({required super.connectionId, required this.topicName});
}

class ConsumeRequest extends FfiRequest {
  final String topic;
  final int? partition;
  final int? offset;
  final int maxMessages;

  ConsumeRequest({
    required super.connectionId,
    required this.topic,
    this.partition,
    this.offset,
    this.maxMessages = 500,
  });
}

class StopConsumeRequest extends FfiRequest {
  StopConsumeRequest(super.connectionId);
}

class ProduceRequest extends FfiRequest {
  final String topic;
  final List<int> value;
  final List<int>? key;
  final int? partition;
  final Map<String, List<int>>? headers;

  ProduceRequest({
    required super.connectionId,
    required this.topic,
    required this.value,
    this.key,
    this.partition,
    this.headers,
  });
}

class ListGroupsRequest extends FfiRequest {
  ListGroupsRequest(super.connectionId);
}

class ResetOffsetsRequest extends FfiRequest {
  final String groupId;
  final String topicName;
  final int offset;

  ResetOffsetsRequest({
    required super.connectionId,
    required this.groupId,
    required this.topicName,
    required this.offset,
  });
}

sealed class FfiResponse {
  final String connectionId;
  FfiResponse(this.connectionId);
}

class ConnectResponse extends FfiResponse {
  final bool success;
  final String? error;
  ConnectResponse({
    required super.connectionId,
    required this.success,
    this.error,
  });
}

class DisconnectResponse extends FfiResponse {
  final bool success;
  DisconnectResponse({required super.connectionId, required this.success});
}

class TopicListResponse extends FfiResponse {
  final List<Map<String, dynamic>> topics;
  TopicListResponse({required super.connectionId, required this.topics});
}

class TopicActionResponse extends FfiResponse {
  final bool success;
  final String? error;
  TopicActionResponse({
    required super.connectionId,
    required this.success,
    this.error,
  });
}

class MessageEvent extends FfiResponse {
  final List<Map<String, dynamic>> messages;
  final bool eof;
  MessageEvent({
    required super.connectionId,
    required this.messages,
    this.eof = false,
  });
}

class ProduceResponse extends FfiResponse {
  final bool success;
  final int? partition;
  final int? offset;
  final String? error;
  ProduceResponse({
    required super.connectionId,
    required this.success,
    this.partition,
    this.offset,
    this.error,
  });
}

class GroupListResponse extends FfiResponse {
  final List<Map<String, dynamic>> groups;
  GroupListResponse({required super.connectionId, required this.groups});
}

class OffsetResetResponse extends FfiResponse {
  final bool success;
  final String? error;
  OffsetResetResponse({
    required super.connectionId,
    required this.success,
    this.error,
  });
}

class LogEvent extends FfiResponse {
  final String level;
  final String message;
  final Map<String, dynamic>? metadata;
  LogEvent({
    required super.connectionId,
    required this.level,
    required this.message,
    this.metadata,
  });
}

class MetadataResponse extends FfiResponse {
  final List<Map<String, dynamic>> brokers;
  final List<Map<String, dynamic>> topics;
  MetadataResponse({
    required super.connectionId,
    required this.brokers,
    required this.topics,
  });
}
