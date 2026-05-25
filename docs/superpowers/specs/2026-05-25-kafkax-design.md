# KafkaX Design Spec

## Overview

KafkaX is a full-featured Kafka desktop client built with Flutter and librdkafka (C library) via FFI. It targets macOS, Linux, and Windows.

**Scope**: Management/monitoring + message development/debugging.
**Out of scope (v1)**: Schema Registry integration.

## Platforms

- macOS (arm64 + x64)
- Linux (x64)
- Windows (x64)

## Architecture

Layered architecture with Isolate isolation for FFI calls.

```
┌─────────────────────────────────────┐
│  Presentation (Widgets + Hooks)      │
│  Riverpod Providers                  │
├─────────────────────────────────────┤
│  Domain (KafkaService, ConnManager)  │
├─────────────────────────────────────┤
│  FFI Wrapper (Isolate-isolated)      │
│  @Native bindings (ffigen + native)  │
├─────────────────────────────────────┤
│  librdkafka (C shared library)       │
└─────────────────────────────────────┘
```

All FFI calls run in a single dedicated Isolate. Main Isolate communicates via `SendPort`/`ReceivePort` with typed `sealed class` messages. This prevents FFI from blocking the UI thread and avoids concurrent native resource access.

## Tech Stack

| Concern | Choice |
|---|---|
| State management | Riverpod with `@riverpod` code-gen |
| Widget lifecycle | flutter_hooks (`HookConsumerWidget`) |
| FFI bindings | ffigen generating `@Native` annotations |
| Library distribution | native_assets |
| Routing | GoRouter |
| Persistence | SharedPreferences + AES-256 encryption |
| Encryption key storage | System keychain (macOS Keychain / Linux libsecret / Windows DPAPI) |

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/                         # Light/dark ThemeData
│   ├── constants/
│   ├── extensions/
│   ├── crypto/                        # AES-256 encrypt/decrypt
│   └── errors/                        # KafkaError sealed class hierarchy
├── data/
│   ├── models/
│   │   ├── connection_config.dart
│   │   ├── topic_info.dart
│   │   ├── partition_info.dart
│   │   ├── consumer_group.dart
│   │   ├── kafka_message.dart
│   │   └── broker_info.dart
│   ├── repositories/
│   │   ├── connection_repository.dart  # Encrypted local storage
│   │   └── settings_repository.dart
│   └── storage/
│       └── secure_storage.dart         # System keychain integration
├── domain/
│   ├── kafka_service.dart              # Unified Kafka operation facade
│   └── connection_manager.dart         # Multi-connection lifecycle
├── ffi/
│   ├── bindings/                       # ffigen-generated @Native bindings
│   │   ├── rd_kafka.dart
│   │   ├── rd_kafka_conf.dart
│   │   ├── rd_kafka_topic.dart
│   │   ├── rd_kafka_consumer.dart
│   │   ├── rd_kafka_producer.dart
│   │   ├── rd_kafka_admin.dart
│   │   └── rd_kafka_metadata.dart
│   ├── types/
│   │   └── rd_kafka_types.dart         # Native structs (Struct + @Packed)
│   ├── callbacks/
│   │   └── rd_kafka_callbacks.dart     # NativeCallable.listener wrappers
│   ├── wrapper/
│   │   ├── kafka_config.dart           # rd_kafka_conf_t wrapper
│   │   ├── kafka_producer.dart
│   │   ├── kafka_consumer.dart
│   │   ├── kafka_admin.dart
│   │   └── kafka_metadata.dart
│   ├── isolate/
│   │   ├── ffi_isolate.dart            # Isolate spawn + message routing
│   │   └── ffi_messages.dart           # Sealed request/response classes
│   └── native/                         # native_assets build script
│       └── build.dart
├── presentation/
│   ├── routes/
│   │   └── app_router.dart
│   ├── screens/
│   │   ├── home/
│   │   ├── cluster/
│   │   ├── topic/
│   │   ├── producer/
│   │   ├── consumer_group/
│   │   └── settings/
│   ├── widgets/
│   ├── hooks/
│   │   ├── use_kafka_connection.dart
│   │   ├── use_kafka_consumer.dart
│   │   ├── use_kafka_producer.dart
│   │   └── use_isolate_message.dart
│   ├── providers/
│   │   ├── connection_providers.dart
│   │   ├── cluster_providers.dart
│   │   ├── topic_providers.dart
│   │   ├── message_providers.dart
│   │   ├── producer_providers.dart
│   │   ├── consumer_group_providers.dart
│   │   ├── settings_providers.dart
│   │   └── log_providers.dart
│   └── panels/
│       └── log_panel.dart              # Collapsible log viewer
├── ffigen.yaml
└── third_party/
    └── librdkafka/
        ├── linux-x64/librdkafka.so
        ├── macos-arm64/librdkafka.dylib
        ├── macos-x64/librdkafka.dylib
        └── windows-x64/librdkafka.dll
```

## FFI Layer

### Bindings (ffigen + native_assets)

`ffigen.yaml` configures `ffi-native: enabled: true` to generate `@Native` annotations. The `native/build.dart` script registers pre-compiled librdkafka shared libraries per platform. Flutter's build system bundles the correct library automatically.

Leaf functions (no callbacks) use `isLeaf: true` for zero-overhead calls.

### Callbacks

librdkafka uses callbacks for message delivery, logs, stats, and errors. These use `NativeCallable.listener` which runs on a separate Dart thread within the FFI Isolate, allowing async event processing.

### Isolate Communication

```dart
// Request/response messages (sealed classes)
sealed class FfiRequest {
  final String connectionId;
  FfiRequest(this.connectionId);
}

sealed class FfiResponse {
  final String connectionId;
  FfiResponse(this.connectionId);
}
```

Key message types:
- **Connect/Disconnect**: Connection lifecycle
- **ListTopics / CreateTopic / DeleteTopic**: Topic CRUD
- **ConsumeRequest / MessageEvent**: Streaming message consumption
- **ProduceRequest**: Message production
- **ListGroups / GroupDescription / ResetOffsets**: Consumer Group management
- **LogEvent**: Application interaction log entries

Single Isolate model: all FFI calls execute serially in one dedicated Isolate to prevent concurrent native resource conflicts. Streaming events (messages, logs) push continuously to main Isolate via `SendPort`.

## UI Layout

### Main Layout: Sidebar + Content Area

```
┌─────────────────────────────────────────┐
│ Toolbar                                 │
├──────────┬──────────────────────────────┤
│ Sidebar  │  Main Content                │
│ (240px)  │  (GoRouter outlet)           │
│          │                              │
│ Dev      │                              │
│  Topics  │                              │
│  Groups  │                              │
│  Produce │                              │
│          │                              │
│ Admin    │                              │
│  Brokers │                              │
├──────────┴──────────────────────────────┤
│ Log Panel (collapsible)                 │
├─────────────────────────────────────────┤
│ Status Bar (connection, broker count)   │
└─────────────────────────────────────────┘
```

Sidebar is collapsible. Connection selector (dropdown) at the top of sidebar.

### Routes

```
/ (ShellRoute - main layout)
├── /home                        → Welcome / quick actions
├── /cluster/:id                 → Cluster overview
├── /cluster/:id/topics          → Topic list
├── /cluster/:id/topics/:name    → Topic detail
│   ├── Tab: Message browser
│   ├── Tab: Config
│   └── Tab: Metrics
├── /cluster/:id/groups          → Consumer Group list
├── /cluster/:id/groups/:gid     → Group detail
│   ├── Tab: Members
│   ├── Tab: Lag monitor
│   └── Tab: Offset management
├── /cluster/:id/produce         → Message producer
├── /cluster/:id/brokers         → Broker list
└── /settings                    → Connection management, theme, crypto config
```

### Key Pages

**Topic Detail**:
- Message browser tab: partition filter, offset/time range input, search box, auto-refresh toggle. Paginated table with columns: Offset | Partition | Key | Value | Timestamp | Headers. Row click expands detail panel (JSON formatted / raw text).
- Config tab: key-value table, editable.
- Metrics tab: partition distribution, message rate chart.

**Message Producer**:
- Topic selector, optional partition, optional key.
- Value editor with format modes: JSON (with formatting + validation), Plain Text, Binary (Hex).
- Dynamic headers editor (add/remove key-value pairs).
- Send button with result display.

**Log Panel**:
- Collapsible panel above status bar.
- Level filter: ALL / INFO / WARN / ERROR.
- Search box, auto-scroll toggle, clear button.
- Virtual-scrolled list with capped size (e.g., last 5000 entries).
- Columns: Timestamp | Level | Connection | Message.

## Data Flow

```
Widget (HookConsumerWidget)
  ├── useKafkaConsumer() hook → manages subscription lifecycle
  ├── ref.watch(messageProvider)
  │
  ▼
Riverpod Provider (AsyncNotifier)
  │
  │ SendPort ──────────┐
  │ ◄── ReceivePort ───┤
  │                     │
  ▼                     ▼
Main Isolate        FFI Isolate
                      ├── KafkaConsumer.consume()
                      │     └── @Native → librdkafka
                      ├── NativeCallable.listener callbacks
                      │     └── SendPort.send(MessageEvent)
                      └── KafkaAdmin / KafkaProducer ...
```

## Error Handling

```dart
sealed class KafkaError implements Exception {
  final String message;
  KafkaError(this.message);
}

class KafkaNativeError extends KafkaError {
  final int code; // rd_kafka_resp_err_t
}

class KafkaConnectionError extends KafkaError {
  final String broker;
}

class KafkaTimeoutError extends KafkaError {
  final Duration timeout;
}

class StorageError extends KafkaError {}
```

Error propagation: FFI Isolate catches native errors → wraps in `FfiResponse(error: KafkaError)` → SendPort to main Isolate → Riverpod `AsyncValue` (AsyncError) → UI `.when(error: ...)`.

## Persistence

Connection configs stored in SharedPreferences, structured as:

```json
{
  "connections": [
    {
      "id": "uuid",
      "name": "Production",
      "brokers": "kafka1:9092,kafka2:9092",
      "auth": {
        "type": "SASL_PLAIN",
        "username": "<AES-256 encrypted>",
        "password": "<AES-256 encrypted>"
      },
      "tls": {
        "enabled": true,
        "caCert": "/path/to/ca.crt",
        "clientCert": "/path/to/client.crt",
        "clientKey": "/path/to/client.key"
      },
      "properties": {
        "socket.timeout.ms": "5000"
      }
    }
  ],
  "settings": {
    "theme": "system",
    "maxMessagesPerFetch": 500,
    "defaultTimeout": 10000
  }
}
```

AES-256 encryption key retrieved from system keychain (macOS Keychain / Linux libsecret / Windows DPAPI). Certificate paths stored as filesystem paths, not file contents.

## Security

- **SASL**: PLAIN, SCRAM, GSSAPI, OAUTHBEARER (via librdkafka built-in support).
- **TLS**: SSL/TLS encrypted connections with optional client certificates.
- **Config encryption**: AES-256 for stored credentials, keys in system keychain.

## Testing

```
test/
├── unit/
│   ├── domain/          # kafka_service, connection_manager
│   ├── data/            # repositories, models (JSON round-trip)
│   ├── ffi/wrapper/     # Integration tests against real Kafka
│   └── core/crypto/     # Encryption tests
├── widget/              # Widget tests with mock providers
└── integration/         # End-to-end flows
```

- **Models/Repositories**: Pure unit tests, in-memory fakes for storage.
- **Domain Service**: Unit tests with mocked FFI wrappers.
- **FFI Wrapper**: Integration tests requiring a real Kafka instance (Docker Compose).
- **Providers**: `ProviderContainer` unit tests verifying state transitions.
- **Widgets**: Widget tests with mocked providers.

Test Kafka cluster via `docker-compose.test.yaml` (Confluent Platform single-node).

## Core Features Summary

1. **Multi-connection management**: Save/switch multiple Kafka clusters.
2. **Topic CRUD**: Create/delete topics, modify partitions/replicas/config.
3. **Message browser**: Real-time consumption, filter by partition/offset/time range, search.
4. **Message producer**: Send messages with JSON/text/binary editor, custom headers.
5. **Consumer Group management**: List groups, view lag/members, reset offsets.
6. **Broker overview**: List brokers, view metadata.
7. **Application log viewer**: Real-time interaction log from librdkafka callbacks.
8. **Security**: SASL auth, TLS encryption, encrypted config storage.
