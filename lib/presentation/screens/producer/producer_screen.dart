import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/l10n/app_localizations.dart';
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
    final s = S.of(context)!;
    final topicsAsync = ref.watch(topicListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.producerTitle)),
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
                    decoration: InputDecoration(
                      labelText: s.producerTopic,
                      border: const OutlineInputBorder(),
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
                    '${s.error}: $e',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Partition input.
                TextField(
                  controller: _partitionController,
                  decoration: InputDecoration(
                    labelText: s.producerPartition,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // Key input.
                TextField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    labelText: s.producerKey,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Value editor.
                TextField(
                  controller: _valueController,
                  decoration: InputDecoration(
                    labelText: s.producerValue,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  minLines: 6,
                ),
                const SizedBox(height: 16),
                // Headers section.
                TextField(
                  controller: _headersController,
                  decoration: InputDecoration(
                    labelText: s.producerHeaders,
                    border: const OutlineInputBorder(),
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
                                '${s.producerSend}: $_selectedTopic',
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.send),
                  label: Text(s.producerSend),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
