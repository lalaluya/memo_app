import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    final isDark = p.bg.computeLuminance() < 0.5;
    return Container(
      height: AppSpacing.statusBarHeight,
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$hh:$mm',
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: p.text,
              letterSpacing: -0.3,
              height: 1.0,
            ),
          ),
          Row(
            children: [
              _SignalBars(color: p.text),
              const SizedBox(width: 5),
              Text(
                '5G',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: p.text,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              _Battery(color: p.text, dark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    final heights = [4.0, 6.0, 8.0, 10.0];
    return SizedBox(
      width: 16,
      height: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final h in heights)
            Padding(
              padding: const EdgeInsets.only(right: 1.5),
              child: Container(
                width: 3,
                height: h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Battery extends StatelessWidget {
  const _Battery({required this.color, required this.dark});
  final Color color;
  final bool dark;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 12,
      child: Stack(
        children: [
          Container(
            width: 24,
            height: 11,
            decoration: BoxDecoration(
              border: Border.all(color: color.withOpacity(0.4), width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
            padding: const EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 4,
            child: Container(
              width: 2,
              height: 5,
              decoration: BoxDecoration(
                color: color.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(1),
                  bottomRight: Radius.circular(1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
