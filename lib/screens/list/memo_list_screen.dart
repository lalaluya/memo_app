import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/memo_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/tab_bar.dart';
import 'widgets/fab.dart';
import 'widgets/memo_item.dart';
import 'widgets/search_box.dart';
import 'widgets/tag_chip_row.dart';

class MemoListScreen extends ConsumerWidget {
  const MemoListScreen({super.key, required this.onTabTap});

  /// Parent needs this callback to switch to tag-filter when a tag is tapped instead of pushing a new stack.
  final void Function(HomeTab tab) onTabTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(filteredMemosProvider);
    final p = context.palette;
    final today = DateTime.now();
    final dateStr = '${today.month}月${today.day}日 · ${_hourLabel(today.hour)} · 拾光';

    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 24, left: AppSpacing.pageHPad, right: AppSpacing.pageHPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '拾光',
                      style: GoogleFonts.notoSerif(
                        fontSize: 32, fontWeight: FontWeight.w500,
                        color: p.text, letterSpacing: 0.05 * 32,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dateStr,
                      style: GoogleFonts.notoSerif(
                        fontSize: 13, color: p.text2, letterSpacing: 0.15 * 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHPad),
                child: SearchBox(),
              ),
              const TagChipRow(),
              Expanded(
                child: list.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (memos) {
                    if (memos.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            '此时无声\n胜有声',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerif(
                              fontSize: 18, color: p.text2,
                              height: 1.8, letterSpacing: 0.2 * 18,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 110),
                      itemCount: memos.length,
                      itemBuilder: (ctx, i) {
                        return MemoListItem(memo: memos[i], index: i);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          right: AppSpacing.pageHPad,
          bottom: AppSpacing.fabBottom,
          child: MemoFab(),
        ),
      ],
    );
  }

  String _hourLabel(int h) {
    if (h < 5) return '夜深';
    if (h < 9) return '清晨';
    if (h < 11) return '上午';
    if (h < 14) return '正午';
    if (h < 18) return '下午';
    if (h < 22) return '傍晚';
    return '夜晚';
  }
}