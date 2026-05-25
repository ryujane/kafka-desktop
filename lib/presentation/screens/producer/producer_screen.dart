import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/presentation/providers/topic_providers.dart';

/// Screen for producing messages to a Kafka topic.
class ProducerScreen extends ConsumerStatefulWidget {
  const ProducerScreen({required this.clusterId, super.key});

  /// The cluster (connection) identifier.
  final String clusterId;

  @override
  ConsumerState<ProducerScreen> createState() => _ProducerScreenState();
}

class _ProducerScreenState extends ConsumerState<ProducerScreen> {
  String? _selectedTopic;
  final _partitionController = TextEditingController();
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  final _headersController = TextEditingController();

  @override
  void dispose() {
    _partitionController.dispose();
    _keyController.dispose();
    _valueController.dispose();
    _headersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(topicListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Produce Message')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Topic selector.
                topicsAsync.when(
                  data: (topics) => DropdownButtonFormField<String>(
                    initialValue: _selectedTopic,
                    decoration: const InputDecoration(
                      labelText: 'Topic',
                      border: OutlineInputBorder(),
                    ),
                    items: topics
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.name,
                            child: Text(t.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedTopic = value);
                    },
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(
                    'Error loading topics: $e',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Partition input.
                TextField(
                  controller: _partitionController,
                  decoration: const InputDecoration(
                    labelText: 'Partition (optional)',
                    border: OutlineInputBorder(),
                    hintText: 'Leave empty for automatic partitioning',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // Key input.
                TextField(
                  controller: _keyController,
                  decoration: const InputDecoration(
                    labelText: 'Key (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Value editor.
                TextField(
                  controller: _valueController,
                  decoration: const InputDecoration(
                    labelText: 'Value',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  minLines: 6,
                ),
                const SizedBox(height: 16),
                // Headers section.
                TextField(
                  controller: _headersController,
                  decoration: const InputDecoration(
                    labelText: 'Headers (optional, JSON)',
                    border: OutlineInputBorder(),
                    hintText: '{"header1": "value1", "header2": "value2"}',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                // Send button.
                FilledButton.icon(
                  onPressed: _selectedTopic == null
                      ? null
                      : () {
                          // TODO: Implement message production.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Send not yet implemented for topic: $_selectedTopic',
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.send),
                  label: const Text('Send Message'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
