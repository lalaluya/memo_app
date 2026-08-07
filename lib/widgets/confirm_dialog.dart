import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// iOS-style confirm dialog.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText = '取消',
    this.confirmText = '确认',
    this.danger = false,
  });

  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final bool danger;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String cancelText = '取消',
    String confirmText = '确认',
    bool danger = false,
  }) async {
    final ok = await showGeneralDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      barrierLabel: '',
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim, _) => ConfirmDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        danger: danger,
      ),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Container(
        width: 280,
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: p.text,
                  letterSpacing: 0.05 * 14,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  fontSize: 12.5,
                  color: p.text2,
                  letterSpacing: 0.05 * 12.5,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label: cancelText,
                      onTap: () => Navigator.of(context).pop(false),
                      filled: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _DialogButton(
                      label: confirmText,
                      onTap: () => Navigator.of(context).pop(true),
                      filled: true,
                      danger: danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onTap,
    required this.filled,
    this.danger = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = filled
        ? (danger ? p.accent : p.accent.withOpacity(0.12))
        : p.inputBg;
    final fg = filled
        ? (danger ? p.fabText : p.accent)
        : p.text2;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: fg,
            letterSpacing: 0.05 * 13,
          ),
        ),
      ),
    );
  }
}