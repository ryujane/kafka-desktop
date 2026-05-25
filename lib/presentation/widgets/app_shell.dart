import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:kafkax/core/theme/theme_extension.dart';
import 'package:kafkax/presentation/widgets/sidebar.dart';
import 'package:kafkax/presentation/widgets/status_bar.dart';
import 'package:kafkax/presentation/panels/log_panel.dart';

/// Main application shell containing sidebar, content area, log panel,
/// and status bar.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({required this.child, super.key});

  /// The routed screen widget to display in the content area.
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _sidebarExpanded = true;
  bool _logPanelExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<KafkaXColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: _sidebarExpanded ? 240 : 56,
                  decoration: BoxDecoration(
                    color:
                        colors.sidebarBackground ??
                        (isDark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFFF5F5F5)),
                    border: Border(
                      right: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Sidebar(
                    expanded: _sidebarExpanded,
                    onToggle: () {
                      setState(() {
                        _sidebarExpanded = !_sidebarExpanded;
                      });
                    },
                  ),
                ),
                Expanded(child: widget.child),
              ],
            ),
          ),
          LogPanel(
            expanded: _logPanelExpanded,
            onToggle: () {
              setState(() {
                _logPanelExpanded = !_logPanelExpanded;
              });
            },
          ),
          StatusBar(
            onLogToggle: () {
              setState(() {
                _logPanelExpanded = !_logPanelExpanded;
              });
            },
            logPanelExpanded: _logPanelExpanded,
          ),
        ],
      ),
    );
  }
}
