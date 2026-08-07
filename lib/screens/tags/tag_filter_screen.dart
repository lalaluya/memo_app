import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/memo_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

class TagFilterScreen extends ConsumerWidget {
  const TagFilterScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final tag = ref.watch(activeTagProvider);
    final list = ref.watch(memosProvider).asData?.value ?? const [];
    final memos = tag == null ? const [] : list.where((m) => m.tag == tag).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHPad, 12, AppSpacing.pageHPad, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Text(
                    '← 拾光',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: p.text,
                      letterSpacing: 0.05 * 13,
                    ),
                  ),
                ),
                Text(
                  tag ?? '',
                  style: GoogleFonts.notoSerif(
                    fontSize: 16,
                    color: p.text,
                    letterSpacing: 0.2 * 16,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          if (memos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Center(
                child: Text(
                  '还没有"$tag"的笔记',
                  style: GoogleFonts.notoSerif(fontSize: 14, color: p.text2),
                ),
              ),
            )
          else
            for (final m in memos)
              GestureDetector(
                onTap: () => Navigator.of(context).pushReplacementNamed(
                    AppRoutes.detail, arguments: m.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  margin: const EdgeInsets.symmetric(horizontal: -16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: p.divider, width: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        style: GoogleFonts.notoSerif(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: p.text,
                          letterSpacing: 0.02 * 19,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSans(
                          fontSize: 13.5,
                          color: p.text2,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            m.displayDate,
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: p.text3,
                              letterSpacing: 0.1 * 11,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(color: p.chipBorder, width: 0.5),
                              borderRadius: BorderRadius.circular(AppRadius.chip),
                            ),
                            child: Text(
                              m.tag,
                              style: GoogleFonts.notoSans(fontSize: 10, color: p.text3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '共 ${memos.length} 篇 · 关于"$tag"',
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: p.text3,
                letterSpacing: 0.2 * 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}