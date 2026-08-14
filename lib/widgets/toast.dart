import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/toast_provider.dart';
import '../theme/app_theme.dart';

class GlobalToast extends ConsumerWidget {
  const GlobalToast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(toastProvider);
    if (info == null) return const SizedBox.shrink();
    return Positioned(
      bottom: 110,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _ToastBubble(key: ValueKey(info.key), info: info),
        ),
      ),
    );
  }
}

class _ToastBubble extends ConsumerWidget {
  const _ToastBubble({super.key, required this.info});
  final ToastInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final bg = p.bg.computeLuminance() < 0.5
        ? p.text.withOpacity(0.94)
        : const Color(0xCC1A1A1A);
    final fg = p.bg.computeLuminance() < 0.5
        ? const Color(0xFF1A1815)
        : const Color(0xFFFAF8F4);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 18,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              info.message,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: fg,
                letterSpacing: 0.05 * 13,
              ),
            ),
            if (info.undoLabel != null && info.onUndo != null) ...[
              const SizedBox(width: 12),
              Container(width: 1, height: 14, color: fg.withOpacity(0.3)),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  info.onUndo?.call();
                  hideToast(ref);
                },
                child: Text(
                  info.undoLabel!,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: p.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
