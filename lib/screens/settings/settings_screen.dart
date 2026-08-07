import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/app_settings.dart';
import '../../providers/memo_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  Future<void> _setPin() async {
    final controller = TextEditingController();
    final ok = await showGeneralDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: '',
      barrierDismissible: true,
      pageBuilder: (ctx, _, __) => _PinDialog(controller: controller),
      transitionBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    );
    if (ok == true && controller.text.length == 4) {
      await ref.read(settingsProvider.notifier).setPin(controller.text);
      await ref.read(settingsProvider.notifier).setLockEnabled(true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已设置 PIN 与加锁')),
        );
      }
    }
  }

  Future<void> _biometricToggle(bool v) async {
    if (v) {
      final auth = LocalAuthentication();
      try {
        final ok = await auth.authenticate(
          localizedReason: '启用生物识别',
          options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
        );
        if (!ok) return;
        await ref.read(settingsProvider.notifier).setBiometric(true);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('当前设备不支持生物识别')),
          );
        }
      }
    } else {
      await ref.read(settingsProvider.notifier).setBiometric(false);
    }
  }

  Future<void> _export() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final memos = ref.read(memosProvider).asData?.value ?? const [];
      final json = jsonEncode({
        'version': 1,
        'exported_at': DateTime.now().toIso8601String(),
        'memos': memos.map((m) => m.toMap()).toList(),
      });
      final dir = await getTemporaryDirectory();
      final file = File(p.join(dir.path,
          'memo-app-${DateTime.now().millisecondsSinceEpoch}.json'));
      await file.writeAsString(json);
      await Share.shareXFiles([XFile(file.path)], text: '拾光笔记导出');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final s = ref.watch(settingsProvider);
    final isDark = p.bg.computeLuminance() < 0.5;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHPad, 12, AppSpacing.pageHPad, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CenterTitleHeader(title: '设置', onBack: () => Navigator.of(context).maybePop()),
          const SizedBox(height: 8),
          const _SectionLabel('外观'),
          _Card(child: Column(children: [
            _Row(label: '深色模式', palette: p,
              trailing: _Switch(
                value: isDark,
                onChanged: (v) async {
                  await ref.read(settingsProvider.notifier).setTheme(v ? 'dark' : 'light');
                },
              ),
              onTap: () async {
                await ref.read(settingsProvider.notifier).setTheme(isDark ? 'light' : 'dark');
              },
            ),
            _Divider(color: p.divider),
            _Row(label: 'OLED 真黑', palette: p,
              trailing: _Switch(
                value: s.oled,
                onChanged: isDark
                    ? (v) async => await ref.read(settingsProvider.notifier).setOled(v)
                    : null,
              ),
            ),
            _Divider(color: p.divider),
            _Row(label: '字号', palette: p,
              trailing: _FontSizePicker(
                value: s.fontSize,
                onChanged: (v) async => await ref.read(settingsProvider.notifier).setFontSize(v),
              ),
            ),
          ])),
          const SizedBox(height: 24),
          const _SectionLabel('隐私'),
          _Card(child: Column(children: [
            _Row(label: '启动加锁', palette: p,
              trailing: _Switch(
                value: s.lockEnabled,
                onChanged: (v) async {
                  if (v && s.pinHash == null) {
                    await _setPin();
                    return;
                  }
                  await ref.read(settingsProvider.notifier).setLockEnabled(v);
                },
              ),
            ),
            _Divider(color: p.divider),
            _Row(label: '生物识别', palette: p,
              trailing: _Switch(
                value: s.biometricEnabled,
                onChanged: s.lockEnabled ? (v) => _biometricToggle(v) : null,
              ),
            ),
            _Divider(color: p.divider),
            _Row(label: '修改 PIN', palette: p, onTap: s.lockEnabled ? _setPin : null),
          ])),
          const SizedBox(height: 24),
          const _SectionLabel('数据'),
          _Card(child: Column(children: [
            _Row(label: '导出全部笔记', palette: p,
              trailing: Text('›', style: GoogleFonts.notoSans(fontSize: 16, color: p.text3)),
              onTap: _busy ? null : _export,
            ),
          ])),
          const SizedBox(height: 24),
          const _SectionLabel('关于'),
          _Card(child: Column(children: [
            _Row(label: '关于拾光', palette: p,
              trailing: Text('v1.0.0 ›', style: GoogleFonts.notoSans(fontSize: 13, color: p.text3)),
              onTap: () => Navigator.of(context).pushNamed('/about'),
            ),
          ])),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PinDialog extends StatefulWidget {
  const _PinDialog({required this.controller});
  final TextEditingController controller;
  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
        decoration: BoxDecoration(color: p.bg, borderRadius: BorderRadius.circular(AppRadius.dialog)),
        child: Material(
          color: Colors.transparent,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('设置 4 位 PIN',
              style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600, color: p.text)),
            const SizedBox(height: 16),
            TextField(
              controller: widget.controller, autofocus: true, maxLength: 4,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              obscureText: true, textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(fontSize: 24, letterSpacing: 8, color: p.text),
              decoration: InputDecoration(
                counterText: '', isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.divider)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.accent)),
              ),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('取消', style: GoogleFonts.notoSans(color: p.text2)),
              )),
              Expanded(child: TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('确认', style: GoogleFonts.notoSans(color: p.accent)),
              )),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(text, style: GoogleFonts.notoSans(fontSize: 11, color: p.text3, letterSpacing: 0.2 * 11)),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(color: p.inputBg, borderRadius: BorderRadius.circular(AppRadius.card)),
      child: child,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Container(height: 0.5, margin: const EdgeInsets.only(left: 16), color: color);
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.palette, this.trailing, this.onTap});
  final String label;
  final AppPalette palette;
  final Widget? trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: GoogleFonts.notoSans(fontSize: 14, color: palette.text, letterSpacing: 0.05 * 14)),
          if (trailing != null) trailing!,
        ]),
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({required this.value, this.onChanged});
  final bool value;
  final ValueChanged<bool>? onChanged;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final enabled = onChanged != null;
    return GestureDetector(
      onTap: enabled ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46, height: 26,
        decoration: BoxDecoration(
          color: value
              ? p.accent
              : (p.bg.computeLuminance() < 0.5 ? Colors.white.withOpacity(0.18) : Colors.black.withOpacity(0.18)),
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.all(2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              color: p.bg.computeLuminance() < 0.5 ? const Color(0xFF1A1815) : const Color(0xFFFAF8F4),
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2))],
            ),
          ),
        ),
      ),
    );
  }
}

class _FontSizePicker extends StatelessWidget {
  const _FontSizePicker({required this.value, required this.onChanged});
  final FontSize value;
  final ValueChanged<FontSize> onChanged;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: p.bg.computeLuminance() < 0.5 ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (final s in FontSize.values)
          GestureDetector(
            onTap: () => onChanged(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: value == s ? p.bg : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: value == s
                    ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 3, offset: const Offset(0, 1))]
                    : null,
              ),
              child: Text(s.label, style: GoogleFonts.notoSans(fontSize: 12, color: value == s ? p.text : p.text2)),
            ),
          ),
      ]),
    );
  }
}