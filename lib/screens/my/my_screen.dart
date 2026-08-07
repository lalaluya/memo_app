import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/memo_provider.dart';
import '../../providers/settings_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final memos = ref.watch(memosProvider).asData?.value ?? const [];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHPad, 12, AppSpacing.pageHPad, 100),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _Avatar(palette: p),
          const SizedBox(height: 14),
          Text(
            '拾光的人',
            style: GoogleFonts.notoSerif(
              fontSize: 22,
              color: p.text,
              letterSpacing: 0.15 * 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '在文字里，慢慢生活',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: p.text3,
              letterSpacing: 0.15 * 12,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: _Stat(num: memos.length.toString(), label: '笔记', palette: p)),
              Expanded(child: _Stat(num: kDefaultTags.length.toString(), label: '标签', palette: p)),
              const Expanded(child: _Stat(num: '12', label: '天', palette: null)),
            ],
          ),
          const SizedBox(height: 24),
          _MenuItem(
            label: '设置',
            enabled: true,
            palette: p,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
          _MenuItem(label: '提醒', enabled: false, palette: p),
          _MenuItem(label: '备份与同步', enabled: false, palette: p),
          _MenuItem(
            label: '关于',
            enabled: true,
            palette: p,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
          ),
          _MenuItem(label: '反馈与建议', enabled: false, palette: p),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.palette});
  final AppPalette palette;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(color: palette.accent, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '拾',
        style: GoogleFonts.notoSerif(
          fontSize: 26,
          color: palette.fabText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.num, required this.label, required this.palette});
  final String num;
  final String label;
  final AppPalette? palette;
  @override
  Widget build(BuildContext context) {
    final p = palette ?? context.palette;
    return Column(
      children: [
        Text(
          num,
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            color: p.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 11,
            color: p.text3,
            letterSpacing: 0.2 * 11,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.label,
    required this.enabled,
    required this.palette,
    this.onTap,
  });
  final String label;
  final bool enabled;
  final AppPalette palette;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: palette.inputBg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: enabled ? palette.text : palette.text3,
                letterSpacing: 0.05 * 14,
              ),
            ),
            enabled
                ? Text('›', style: GoogleFonts.notoSans(fontSize: 16, color: palette.text3))
                : Text(
                    '敬请期待',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: palette.text3,
                      letterSpacing: 0.1 * 11,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}