import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../router/app_router.dart';
import '../../../theme/app_theme.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.search),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: p.inputBg,
          borderRadius: BorderRadius.circular(AppRadius.searchBox),
        ),
        child: Text(
          '搜索一个词、一段心情…',
          style: GoogleFonts.notoSans(
            fontSize: 13, color: p.inputPlaceholder, letterSpacing: 0.05 * 13,
          ),
        ),
      ),
    );
  }
}