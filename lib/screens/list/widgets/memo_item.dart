import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/memo.dart';
import '../../../router/app_router.dart';
import '../../../theme/app_theme.dart';

class MemoListItem extends StatefulWidget {
  const MemoListItem({super.key, required this.memo, required this.index});
  final Memo memo;
  final int index;

  @override
  State<MemoListItem> createState() => _MemoListItemState();
}

class _MemoListItemState extends State<MemoListItem> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _opacity = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _offset = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    final delay = (widget.index.clamp(0, 6)) * 70;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final m = widget.memo;
    return SlideTransition(
      position: _offset,
      child: FadeTransition(
        opacity: _opacity,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (m.id != null) {
              Navigator.of(context).pushNamed(AppRoutes.detail, arguments: m.id);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            margin: const EdgeInsets.symmetric(horizontal: -16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: p.divider, width: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style: GoogleFonts.notoSerif(
                    fontSize: 19, fontWeight: FontWeight.w500,
                    color: p.text, letterSpacing: 0.02 * 19,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  m.preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSans(
                    fontSize: 13.5, color: p.text2, height: 1.7, letterSpacing: 0.02 * 13.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      m.displayDate,
                      style: GoogleFonts.notoSans(
                        fontSize: 11, color: p.text3, letterSpacing: 0.1 * 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                      decoration: BoxDecoration(
                        border: Border.all(color: p.chipBorder, width: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                      ),
                      child: Text(
                        m.tag,
                        style: GoogleFonts.notoSans(fontSize: 10, color: p.text3, letterSpacing: 0.05 * 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}