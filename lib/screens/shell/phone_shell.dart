import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../../widgets/dynamic_island.dart';
import '../../widgets/home_indicator.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/tab_bar.dart';
import '../../widgets/toast.dart';

/// iOS-style device shell + status bar + dynamic island + Home Indicator + global toast.
/// In debug shows full device frame; in release directly full-screen.
class PhoneShell extends ConsumerWidget {
  const PhoneShell({
    super.key,
    required this.child,
    this.showTabBar = false,
    this.currentTab = HomeTab.list,
    this.onTabTap,
  });

  final Widget child;
  final bool showTabBar;
  final HomeTab currentTab;
  final ValueChanged<HomeTab>? onTabTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    return Scaffold(
      backgroundColor: const Color(0xFFE8E4DC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            width: 393,
            height: 852,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.phone),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: p.bg.computeLuminance() < 0.5
                    ? [const Color(0xFF0A0907), const Color(0xFF000000)]
                    : [const Color(0xFF2A2A2C), const Color(0xFF0A0A0B)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 100,
                  offset: const Offset(0, 40),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.phoneInner),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ColoredBox(color: p.bg),
                  ),
                  const DynamicIsland(),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: StatusBar(),
                  ),
                  Positioned.fill(
                    top: AppSpacing.statusBarHeight,
                    child: child,
                  ),
                  if (showTabBar && onTabTap != null)
                    HomeTabBar(current: currentTab, onTap: onTabTap!),
                  const HomeIndicator(),
                  const GlobalToast(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
