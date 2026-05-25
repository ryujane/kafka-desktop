import 'package:flutter/material.dart';

@immutable
class KafkaXColors extends ThemeExtension<KafkaXColors> {
  const KafkaXColors({
    required this.sidebarBackground,
    required this.statusBarBackground,
    required this.connectionOnline,
    required this.connectionOffline,
    required this.logInfo,
    required this.logWarn,
    required this.logError,
  });

  final Color? sidebarBackground;
  final Color? statusBarBackground;
  final Color? connectionOnline;
  final Color? connectionOffline;
  final Color? logInfo;
  final Color? logWarn;
  final Color? logError;

  @override
  KafkaXColors copyWith({
    Color? sidebarBackground,
    Color? statusBarBackground,
    Color? connectionOnline,
    Color? connectionOffline,
    Color? logInfo,
    Color? logWarn,
    Color? logError,
  }) {
    return KafkaXColors(
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      statusBarBackground: statusBarBackground ?? this.statusBarBackground,
      connectionOnline: connectionOnline ?? this.connectionOnline,
      connectionOffline: connectionOffline ?? this.connectionOffline,
      logInfo: logInfo ?? this.logInfo,
      logWarn: logWarn ?? this.logWarn,
      logError: logError ?? this.logError,
    );
  }

  @override
  KafkaXColors lerp(ThemeExtension<KafkaXColors>? other, double t) {
    if (other is! KafkaXColors) return this;
    return KafkaXColors(
      sidebarBackground: Color.lerp(
        sidebarBackground,
        other.sidebarBackground,
        t,
      ),
      statusBarBackground: Color.lerp(
        statusBarBackground,
        other.statusBarBackground,
        t,
      ),
      connectionOnline: Color.lerp(connectionOnline, other.connectionOnline, t),
      connectionOffline: Color.lerp(
        connectionOffline,
        other.connectionOffline,
        t,
      ),
      logInfo: Color.lerp(logInfo, other.logInfo, t),
      logWarn: Color.lerp(logWarn, other.logWarn, t),
      logError: Color.lerp(logError, other.logError, t),
    );
  }
}
