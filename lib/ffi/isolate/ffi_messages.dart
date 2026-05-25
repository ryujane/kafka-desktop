sealed class FfiRequest {
  final String connectionId;
  FfiRequest(this.connectionId);
}

class ShutdownRequest extends FfiRequest {
  ShutdownRequest() : super('_shutdown');
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
    required String connectionId,
    required this.brokers,
    this.authType,
    this.username,
    this.password,
    this.tlsEnabled = false,
    this.caCertPath,
    this.properties = const {},
  }) : super(connectionId);
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
    required String connectionId,
    required this.name,
    required this.partitions,
    required this.replicationFactor,
    this.config = const {},
  }) : super(connectionId);
}

class DeleteTopicRequest extends FfiRequest {
  final String topicName;
  DeleteTopicRequest({required String connectionId, required this.topicName})
    : super(connectionId);
}

class ConsumeRequest extends FfiRequest {
  final String topic;
  final int? partition;
  final int? offset;
  final int maxMessages;

  ConsumeRequest({
    required String connectionId,
    required this.topic,
    this.partition,
    this.offset,
    this.maxMessages = 500,
  }) : super(connectionId);
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
    required String connectionId,
    required this.topic,
    required this.value,
    this.key,
    this.partition,
    this.headers,
  }) : super(connectionId);
}

class ListGroupsRequest extends FfiRequest {
  ListGroupsRequest(super.connectionId);
}

class ResetOffsetsRequest extends FfiRequest {
  final String groupId;
  final String topicName;
  final int offset;

  ResetOffsetsRequest({
    required String connectionId,
    required this.groupId,
    required this.topicName,
    required this.offset,
  }) : super(connectionId);
}

sealed class FfiResponse {
  final String connectionId;
  FfiResponse(this.connectionId);
}

class ConnectResponse extends FfiResponse {
  final bool success;
  final String? error;
  ConnectResponse({
    required String connectionId,
    required this.success,
    this.error,
  }) : super(connectionId);
}

class DisconnectResponse extends FfiResponse {
  final bool success;
  DisconnectResponse({required String connectionId, required this.success})
    : super(connectionId);
}

class TopicListResponse extends FfiResponse {
  final List<Map<String, dynamic>> topics;
  TopicListResponse({required String connectionId, required this.topics})
    : super(connectionId);
}

class TopicActionResponse extends FfiResponse {
  final bool success;
  final String? error;
  TopicActionResponse({
    required String connectionId,
    required this.success,
    this.error,
  }) : super(connectionId);
}

class MessageEvent extends FfiResponse {
  final List<Map<String, dynamic>> messages;
  final bool eof;
  MessageEvent({
    required String connectionId,
    required this.messages,
    this.eof = false,
  }) : super(connectionId);
}

class ProduceResponse extends FfiResponse {
  final bool success;
  final int? partition;
  final int? offset;
  final String? error;
  ProduceResponse({
    required String connectionId,
    required this.success,
    this.partition,
    this.offset,
    this.error,
  }) : super(connectionId);
}

class GroupListResponse extends FfiResponse {
  final List<Map<String, dynamic>> groups;
  GroupListResponse({required String connectionId, required this.groups})
    : super(connectionId);
}

class OffsetResetResponse extends FfiResponse {
  final bool success;
  final String? error;
  OffsetResetResponse({
    required String connectionId,
    required this.success,
    this.error,
  }) : super(connectionId);
}

class LogEvent extends FfiResponse {
  final String level;
  final String message;
  final Map<String, dynamic>? metadata;
  LogEvent({
    required String connectionId,
    required this.level,
    required this.message,
    this.metadata,
  }) : super(connectionId);
}

class MetadataResponse extends FfiResponse {
  final List<Map<String, dynamic>> brokers;
  final List<Map<String, dynamic>> topics;
  MetadataResponse({
    required String connectionId,
    required this.brokers,
    required this.topics,
  }) : super(connectionId);
}
