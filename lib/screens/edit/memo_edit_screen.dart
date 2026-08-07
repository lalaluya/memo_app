import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/app_settings.dart';
import '../../data/models/memo.dart';
import '../../providers/memo_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/toast_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header.dart';

class MemoEditScreen extends ConsumerStatefulWidget {
  const MemoEditScreen({super.key, this.memoId});
  final int? memoId;
  @override
  ConsumerState<MemoEditScreen> createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends ConsumerState<MemoEditScreen> {
  late final TextEditingController _title;
  late final TextEditingController _body;
  late String _tag;
  Memo? _origin;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.memoId == null ? null : ref.read(memoByIdProvider(widget.memoId!));
    _origin = m;
    _title = TextEditingController(text: m?.title ?? '');
    _body = TextEditingController(text: m?.body ?? '');
    _tag = m?.tag ?? kDefaultTags.first;
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (_title.text.trim().isEmpty && _body.text.trim().isEmpty) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _saving = true);
    final now = DateTime.now();
    if (_origin == null) {
      final m = Memo(
        title: _title.text.trim().isEmpty ? 'untitled' : _title.text.trim(),
        body: _body.text,
        tag: _tag,
        createdAt: now,
        updatedAt: now,
      );
      await ref.read(memosProvider.notifier).create(m);
    } else {
      await ref.read(memosProvider.notifier).update(_origin!.copyWith(
            title: _title.text.trim().isEmpty ? 'untitled' : _title.text.trim(),
            body: _body.text,
            tag: _tag,
            updatedAt: now,
          ));
    }
    if (!mounted) return;
    showToast(ref, message: 'saved', durationMs: 1800);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final fontPx = ref.watch(settingsProvider).fontSize.fontPx;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHPad, 12, AppSpacing.pageHPad, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditHeader(
            onCancel: () => Navigator.of(context).maybePop(),
            onDone: _save,
          ),
          TextField(
            controller: _title,
            style: GoogleFonts.notoSerif(
              fontSize: 22, fontWeight: FontWeight.w500,
              color: p.text, letterSpacing: 0.02 * 22,
            ),
            decoration: InputDecoration(
              border: InputBorder.none, isDense: true,
              hintText: 'a title',
              hintStyle: GoogleFonts.notoSerif(
                fontSize: 22, fontWeight: FontWeight.w500, color: p.text3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _body,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: GoogleFonts.notoSans(
              fontSize: fontPx.toDouble(), color: p.text,
              height: 1.85, letterSpacing: 0.02 * fontPx,
            ),
            decoration: InputDecoration(
              border: InputBorder.none, isDense: true,
              hintText: 'what is on your mind?',
              hintStyle: GoogleFonts.notoSans(fontSize: fontPx.toDouble(), color: p.text3),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'pick a tag',
            style: GoogleFonts.notoSans(fontSize: 11, color: p.text3, letterSpacing: 0.2 * 11),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              for (final t in kDefaultTags)
                _Chip(label: t, selected: _tag == t, onTap: () => setState(() => _tag = t)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? p.selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: selected ? p.chipBorderActive : p.chipBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 12, color: selected ? p.selectedText : p.text2, letterSpacing: 0.05 * 12,
          ),
        ),
      ),
    );
  }
}