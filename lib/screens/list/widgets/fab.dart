import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../router/app_router.dart';
import '../../../theme/app_theme.dart';

class MemoFab extends StatefulWidget {
  const MemoFab({super.key});

  @override
  State<MemoFab> createState() => _MemoFabState();
}

class _MemoFabState extends State<MemoFab> {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.92),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () =>
          Navigator.of(context).pushNamed(AppRoutes.edit, arguments: null),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Container(
          width: AppSpacing.fabSize,
          height: AppSpacing.fabSize,
          decoration: BoxDecoration(
            color: p.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: p.accent.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: p.accent.withOpacity(0.35),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '+',
            style: GoogleFonts.notoSans(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: p.fabText,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
