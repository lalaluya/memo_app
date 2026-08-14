import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

enum HomeTab { list, tags, my }

extension HomeTabX on HomeTab {
  String get label => switch (this) {
        HomeTab.list => '笔记',
        HomeTab.tags => '标签',
        HomeTab.my => '我的',
      };
}

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({
    super.key,
    required this.current,
    required this.onTap,
  });
  final HomeTab current;
  final ValueChanged<HomeTab> onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: AppSpacing.tabBarHeight,
            decoration: BoxDecoration(
              color: p.bg.withOpacity(0.85),
              border: Border(
                top: BorderSide(color: p.divider, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final t in HomeTab.values)
                  _TabItem(
                    label: t.label,
                    active: t == current,
                    onTap: () => onTap(t),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              SizedBox(
                height: 3,
                width: 3,
                child: active
                    ? Container(
                        decoration: BoxDecoration(
                          color: p.accent,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  label,
                  style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: active ? p.text : p.text3,
                    letterSpacing: 0.2 * 10, // 0.2em
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
