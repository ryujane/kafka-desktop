import 'package:flutter_test/flutter_test.dart';
import 'package:kafkax/data/models/topic_info.dart';

void main() {
  test('TopicInfo fromJson parses correctly', () {
    final json = {
      'name': 'test-topic',
      'partitions': [
        {
          'id': 0,
          'leader': 1,
          'replicas': [1, 2, 3],
        },
        {
          'id': 1,
          'leader': 2,
          'replicas': [2, 3, 1],
        },
      ],
      'is_internal': false,
    };
    final topic = TopicInfo.fromJson(json);
    expect(topic.name, 'test-topic');
    expect(topic.partitions.length, 2);
    expect(topic.partitions[0].leader, 1);
    expect(topic.isInternal, false);
  });
}
