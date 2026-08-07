import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/memo_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../theme/app_theme.dart';

class TagChipRow extends ConsumerWidget {
  const TagChipRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeTagProvider);
    final tags = kDefaultTags;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(AppSpacing.pageHPad, 0, AppSpacing.pageHPad, 12),
        child: Row(
          children: [
            for (final t in tags) ...[
              _Chip(label: t, active: active == t, onTap: () {
                ref.read(activeTagProvider.notifier).state = active == t ? null : t;
              }),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? p.selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: active ? p.chipBorderActive : p.chipBorder, width: 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 12, color: active ? p.selectedText : p.text2, letterSpacing: 0.05 * 12,
          ),
        ),
      ),
    );
  }
}