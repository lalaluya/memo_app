import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: p.divider, width: 1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            '此时无声\n胜有声',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerif(
              fontSize: 18,
              color: p.text2,
              height: 1.8,
              letterSpacing: 0.2 * 18,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '点右下角的圆 · 写下第一句',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: p.text3,
              letterSpacing: 0.15 * 12,
            ),
          ),
        ],
      ),
    );
  }
}