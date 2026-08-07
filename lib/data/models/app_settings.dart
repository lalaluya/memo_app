import 'package:flutter/foundation.dart';

enum FontSize { small, medium, large }

extension FontSizeX on FontSize {
  String get label => switch (this) {
        FontSize.small => '细',
        FontSize.medium => '常',
        FontSize.large => '粗',
      };
  double get fontPx => switch (this) {
        FontSize.small => 14,
        FontSize.medium => 16,
        FontSize.large => 18,
      };
}

@immutable
class AppSettings {
  final String theme;
  final bool oled;
  final FontSize fontSize;
  final bool lockEnabled;
  final bool biometricEnabled;
  final String? pinHash;
  final bool autoBackup;

  const AppSettings({
    this.theme = 'light',
    this.oled = false,
    this.fontSize = FontSize.medium,
    this.lockEnabled = false,
    this.biometricEnabled = false,
    this.pinHash,
    this.autoBackup = false,
  });

  AppSettings copyWith({
    String? theme,
    bool? oled,
    FontSize? fontSize,
    bool? lockEnabled,
    bool? biometricEnabled,
    String? pinHash,
    bool? autoBackup,
  }) =>
      AppSettings(
        theme: theme ?? this.theme,
        oled: oled ?? this.oled,
        fontSize: fontSize ?? this.fontSize,
        lockEnabled: lockEnabled ?? this.lockEnabled,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        pinHash: pinHash ?? this.pinHash,
        autoBackup: autoBackup ?? this.autoBackup,
      );
}