import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key, required this.onUnlock});
  final VoidCallback onUnlock;
  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _focus.requestFocus();
      final s = ref.read(settingsProvider);
      if (s.biometricEnabled) {
        final auth = LocalAuthentication();
        try {
          final ok = await auth.authenticate(
            localizedReason: '解锁拾光',
            options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
          );
          if (ok) widget.onUnlock();
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    final v = _ctrl.text;
    if (v.length != 4) {
      setState(() => _error = '请输入 4 位数字');
      return;
    }
    final ok = ref.read(settingsProvider.notifier).verifyPin(v);
    if (ok) {
      widget.onUnlock();
    } else {
      setState(() {
        _error = 'PIN 不正确';
        _ctrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: p.accent,
                borderRadius: BorderRadius.circular(AppRadius.aboutLogo),
              ),
              alignment: Alignment.center,
              child: Text('拾', style: GoogleFonts.notoSerif(fontSize: 32, color: p.fabText)),
            ),
            const SizedBox(height: 24),
            Text(
              '请输入 PIN',
              style: GoogleFonts.notoSans(
                fontSize: 14, color: p.text2, letterSpacing: 0.2 * 14,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: p.inputBg,
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
              child: TextField(
                controller: _ctrl,
                focusNode: _focus,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(fontSize: 22, letterSpacing: 12, color: p.text),
                decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: GoogleFonts.notoSans(fontSize: 12, color: p.accent)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _submit,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                decoration: BoxDecoration(color: p.accent, borderRadius: BorderRadius.circular(999)),
                child: Text('解锁', style: GoogleFonts.notoSans(fontSize: 14, color: p.fabText)),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}