import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/app_settings.dart';
import '../../data/models/memo.dart';
import '../../providers/memo_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/toast_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/header.dart';
import '../empty/empty_screen.dart';

class MemoDetailScreen extends ConsumerWidget {
  const MemoDetailScreen({super.key, required this.memoId});
  final int memoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memo = ref.watch(memoByIdProvider(memoId));
    final p = context.palette;
    final fontPx = ref.watch(settingsProvider).fontSize.fontPx;

    if (memo == null) {
      return const EmptyScreen();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHPad, 12, AppSpacing.pageHPad, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailHeader(
            title: memo.title,
            onBack: () => Navigator.of(context).maybePop(),
            onEdit: () => Navigator.of(context).pushReplacementNamed(
              '/edit',
              arguments: memo.id,
            ),
          ),
          Text(
            memo.title,
            style: GoogleFonts.notoSerif(
              fontSize: 26, fontWeight: FontWeight.w500,
              color: p.text, height: 1.5, letterSpacing: 0.02 * 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${memo.displayDate} / ${memo.tag}',
            style: GoogleFonts.notoSans(fontSize: 12, color: p.text3, letterSpacing: 0.15 * 12),
          ),
          const SizedBox(height: 32),
          Text(
            memo.body,
            style: GoogleFonts.notoSans(
              fontSize: fontPx.toDouble(), color: p.text,
              height: 1.85, letterSpacing: 0.02 * fontPx,
            ),
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () => _confirmDelete(context, ref, memo),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: p.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
              alignment: Alignment.center,
              child: Text(
                'delete this memo',
                style: GoogleFonts.notoSans(
                  fontSize: 13, color: p.accent, fontWeight: FontWeight.w500,
                  letterSpacing: 0.05 * 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Memo memo) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete this memo?',
      message: 'You can undo within 5 seconds.',
      confirmText: 'Delete',
      danger: true,
    );
    if (!ok) return;
    final id = memo.id!;
    await ref.read(memosProvider.notifier).delete(id);
    if (context.mounted) Navigator.of(context).pop();
    showToast(
      ref,
      message: 'deleted',
      undoLabel: 'undo',
      durationMs: 4000,
      onUndo: () async {
        await ref.read(memosProvider.notifier).restore(memo);
      },
    );
  }
}