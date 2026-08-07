import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/models/app_settings.dart';
import '../theme/app_theme.dart';

const _kKey = 'app_settings_v1';
const _storage = FlutterSecureStorage();

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final raw = await _storage.read(key: _kKey);
    if (raw == null) return;
    try {
      final m = _decode(raw);
      state = AppSettings(
        theme: (m['theme'] as String?) ?? 'light',
        oled: (m['oled'] as String?) == 'true',
        fontSize: FontSize.values[
            int.tryParse((m['fontSize'] as String?) ?? '1') ?? 1],
        lockEnabled: (m['lockEnabled'] as String?) == 'true',
        biometricEnabled: (m['biometricEnabled'] as String?) == 'true',
        pinHash: m['pinHash'] as String?,
        autoBackup: (m['autoBackup'] as String?) == 'true',
      );
    } catch (_) {}
  }

  Future<void> _save() async {
    await _storage.write(key: _kKey, value: _encode(state));
  }

  Future<void> setTheme(String v) async {
    state = state.copyWith(theme: v);
    await _save();
  }

  Future<void> setOled(bool v) async {
    state = state.copyWith(oled: v);
    await _save();
  }

  Future<void> setFontSize(FontSize v) async {
    state = state.copyWith(fontSize: v);
    await _save();
  }

  Future<void> setLockEnabled(bool v) async {
    state = state.copyWith(lockEnabled: v);
    await _save();
  }

  Future<void> setBiometric(bool v) async {
    state = state.copyWith(biometricEnabled: v);
    await _save();
  }

  Future<void> setPin(String? pin) async {
    state = state.copyWith(pinHash: pin == null ? null : _hashPin(pin));
    await _save();
  }

  Future<void> setAutoBackup(bool v) async {
    state = state.copyWith(autoBackup: v);
    await _save();
  }

  bool verifyPin(String pin) => _hashPin(pin) == state.pinHash;

  static String _hashPin(String pin) => pin
      .split('')
      .fold<int>(0,
          (acc, ch) => ((acc * 31) + ch.codeUnitAt(0)) & 0x7FFFFFFF)
      .toString();

  static Map<String, String?> _decode(String raw) {
    final out = <String, String?>{};
    for (final part in raw.split('|')) {
      final kv = part.split('=');
      if (kv.length != 2) continue;
      out[kv[0]] = kv[1];
    }
    return out;
  }

  static String _encode(AppSettings s) {
    String v(Object? x) => (x ?? '').toString();
    return [
      'theme=${v(s.theme)}',
      'oled=${v(s.oled)}',
      'fontSize=${s.fontSize.index}',
      'lockEnabled=${v(s.lockEnabled)}',
      'biometricEnabled=${v(s.biometricEnabled)}',
      'pinHash=${v(s.pinHash)}',
      'autoBackup=${v(s.autoBackup)}',
    ].join('|');
  }
}

final effectiveThemeModeProvider = Provider<ThemeMode>((ref) {
  final s = ref.watch(settingsProvider);
  return switch (s.theme) {
    'dark' => ThemeMode.dark,
    'light' => ThemeMode.light,
    _ => ThemeMode.system,
  };
});

final effectivePaletteProvider = Provider<AppPalette>((ref) {
  final mode = ref.watch(effectiveThemeModeProvider);
  final s = ref.watch(settingsProvider);
  final brightness = switch (mode) {
    ThemeMode.dark => Brightness.dark,
    ThemeMode.light => Brightness.light,
    ThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
  };
  return brightness == Brightness.dark
      ? AppPalette.dark(oled: s.oled)
      : AppPalette.light;
});

const kDefaultTags = ['鏃ュ父', '闅忔兂', '鎽樺綍', '寰呭姙'];
