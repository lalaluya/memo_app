import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/memo.dart';
import '../../providers/memo_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import '../../utils/highlight_text.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  List<Memo> _results = const [];
  String _q = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
    _ctrl.addListener(_onChange);
  }

  Future<void> _onChange() async {
    final q = _ctrl.text;
    setState(() => _q = q);
    if (q.trim().isEmpty) {
      setState(() => _results = const []);
      return;
    }
    final list = await ref.read(memosProvider.notifier).search(q);
    if (mounted) setState(() => _results = list);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onChange);
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHPad, 12, AppSpacing.pageHPad, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).maybePop(),
                child: Text(
                  '← 返回',
                  style: GoogleFonts.notoSans(fontSize: 13, color: p.text, letterSpacing: 0.05 * 13),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: p.inputBg,
                    borderRadius: BorderRadius.circular(AppRadius.input),
                  ),
                  child: TextField(
                    controller: _ctrl,
                    focusNode: _focus,
                    decoration: InputDecoration(
                      border: InputBorder.none, isDense: true,
                      hintText: '搜索一个词、一段心情…',
                      hintStyle: GoogleFonts.notoSans(fontSize: 14, color: p.inputPlaceholder),
                    ),
                    style: GoogleFonts.notoSans(fontSize: 14, color: p.text, letterSpacing: 0.05 * 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_q.trim().isEmpty)
            const _Empty(poem: '不搜\n也是一种搜寻', sub: '输入关键词 · 试试"雨"')
          else if (_results.isEmpty)
            _Empty(poem: '此处无声', sub: '没找到关于"$_q"的笔记')
          else ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '找到 ${_results.length} 篇 · 关于"$_q"',
                style: GoogleFonts.notoSans(fontSize: 11, color: p.text3, letterSpacing: 0.15 * 11),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (ctx, i) {
                  final m = _results[i];
                  return _SearchResultItem(memo: m, query: _q);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({required this.memo, required this.query});
  final Memo memo;
  final String query;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final base = GoogleFonts.notoSans(
      fontSize: 13.5, color: p.text2, height: 1.7,
    );
    final titleBase = GoogleFonts.notoSerif(
      fontSize: 19, fontWeight: FontWeight.w500,
      color: p.text, letterSpacing: 0.02 * 19,
    );
    final hl = GoogleFonts.notoSans(
      fontSize: 13.5, color: p.highlightText,
      backgroundColor: p.highlightBg, fontWeight: FontWeight.w500,
    );
    final hlTitle = GoogleFonts.notoSerif(
      fontSize: 19, fontWeight: FontWeight.w500,
      color: p.highlightText, backgroundColor: p.highlightBg,
      letterSpacing: 0.02 * 19,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushReplacementNamed(
          AppRoutes.detail, arguments: memo.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        margin: const EdgeInsets.symmetric(horizontal: -16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: p.divider, width: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: buildHighlightSpan(memo.title, query,
                  baseStyle: titleBase, highlightStyle: hlTitle),
            ),
            const SizedBox(height: 6),
            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: buildHighlightSpan(memo.preview, query,
                  baseStyle: base, highlightStyle: hl),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  memo.displayDate,
                  style: GoogleFonts.notoSans(fontSize: 11, color: p.text3, letterSpacing: 0.1 * 11),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    border: Border.all(color: p.chipBorder, width: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(
                    memo.tag,
                    style: GoogleFonts.notoSans(fontSize: 10, color: p.text3, letterSpacing: 0.05 * 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.poem, required this.sub});
  final String poem;
  final String sub;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              poem,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerif(
                fontSize: 16, color: p.text2, height: 2, letterSpacing: 0.2 * 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              sub,
              style: GoogleFonts.notoSans(fontSize: 12, color: p.text3, letterSpacing: 0.15 * 12),
            ),
          ],
        ),
      ),
    );
  }
}