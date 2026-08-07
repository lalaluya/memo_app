import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Detail screen header: back + center title + right action
class DetailHeader extends StatelessWidget {
  const DetailHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.onEdit,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onBack,
            child: Text(
              '← 拾光',
              style: GoogleFonts.notoSans(fontSize: 13, color: p.text, letterSpacing: 0.05 * 13),
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onEdit,
              child: Text(
                '编辑',
                style: GoogleFonts.notoSans(fontSize: 13, color: p.text2, letterSpacing: 0.05 * 13),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// Edit screen header: cancel / done
class EditHeader extends StatelessWidget {
  const EditHeader({super.key, required this.onCancel, required this.onDone});

  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onCancel,
            child: Text(
              '取消',
              style: GoogleFonts.notoSans(fontSize: 13, color: p.text2, letterSpacing: 0.05 * 13),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDone,
            child: Text(
              '完成',
              style: GoogleFonts.notoSans(
                fontSize: 13, fontWeight: FontWeight.w600, color: p.accent, letterSpacing: 0.05 * 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Centered title header
class CenterTitleHeader extends StatelessWidget {
  const CenterTitleHeader({super.key, required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onBack,
            child: Text(
              '← 返回',
              style: GoogleFonts.notoSans(fontSize: 13, color: p.text, letterSpacing: 0.05 * 13),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.notoSerif(fontSize: 16, color: p.text, letterSpacing: 0.2 * 16),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}