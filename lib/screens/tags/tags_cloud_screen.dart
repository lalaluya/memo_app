import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/memo_provider.dart';
import '../../providers/settings_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

class TagsCloudScreen extends ConsumerWidget {
  const TagsCloudScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final all = ref.watch(memosProvider).asData?.value ?? const [];
    final counts = <String, int>{};
    for (final t in kDefaultTags) {
      counts[t] = all.where((m) => m.tag == t).length;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHPad, 12, AppSpacing.pageHPad, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '所有标签',
                  style: GoogleFonts.notoSerif(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: p.text,
                    letterSpacing: 0.05 * 26,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '点击查看该标签下的笔记',
                  style: GoogleFonts.notoSerif(
                    fontSize: 13,
                    color: p.text2,
                    letterSpacing: 0.15 * 13,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final t in kDefaultTags)
                _TagCloudItem(
                  label: t,
                  count: counts[t] ?? 0,
                  onTap: () {
                    ref.read(activeTagProvider.notifier).state = t;
                    Navigator.of(context).pushNamed(AppRoutes.tagFilter);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagCloudItem extends StatelessWidget {
  const _TagCloudItem({
    required this.label,
    required this.count,
    required this.onTap,
  });
  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: p.inputBg,
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: p.text,
                letterSpacing: 0.05 * 14,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '· $count',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: p.text3,
                letterSpacing: 0.05 * 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}