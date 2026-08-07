import 'package:flutter/material.dart';

/// 鎷惧厜 路 鐑涚儸绗旇 涓婚
/// 瀵瑰簲鍘熷瀷鐨?:root 涓?[data-theme="dark"] CSS 鍙橀噺
class AppColors {
  // Light
  static const Color lightBg = Color(0xFFFAF8F4);
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightText2 = Color(0xFF6B6B6B);
  static const Color lightText3 = Color(0xFFB0ACA5);
  static const Color lightDivider = Color(0x12000000); // rgba(0,0,0,0.07)
  static const Color lightDividerStrong = Color(0x1F000000);
  static const Color lightAccent = Color(0xFFC04A1A); // 鏈辩爞
  static const Color lightSelectedBg = Color(0xFF1A1A1A);
  static const Color lightSelectedText = Color(0xFFFAF8F4);
  static const Color lightChipBorder = Color(0xFFE5E2DC);
  static const Color lightChipBorderActive = Color(0xFF1A1A1A);
  static const Color lightInputBg = Color(0x0A000000); // rgba(0,0,0,0.04)
  static const Color lightInputPlaceholder = Color(0xFF948D85);
  static const Color lightHighlightBg = Color(0x1FC04A1A);
  static const Color lightHighlightText = Color(0xFFC04A1A);
  static const Color lightDialogOverlay = Color(0x59000000);
  static const Color lightHomeIndicator = Color(0xFF1A1A1A);
  static const Color lightFabText = Color(0xFFFAF8F4);

  // Dark
  static const Color darkBg = Color(0xFF1A1815);
  static const Color darkText = Color(0xFFE8E2D5);
  static const Color darkText2 = Color(0xFFA8A39A);
  static const Color darkText3 = Color(0xFF6A645C);
  static const Color darkDivider = Color(0x14FFFFFF);
  static const Color darkDividerStrong = Color(0x24FFFFFF);
  static const Color darkAccent = Color(0xFFD86A38); // 鏆栨
  static const Color darkSelectedBg = Color(0xFFE8E2D5);
  static const Color darkSelectedText = Color(0xFF1A1815);
  static const Color darkChipBorder = Color(0xFF3A3530);
  static const Color darkChipBorderActive = Color(0xFFE8E2D5);
  static const Color darkInputBg = Color(0x0FFFFFFF);
  static const Color darkInputPlaceholder = Color(0xFF7A756D);
  static const Color darkHighlightBg = Color(0x33D86A38);
  static const Color darkHighlightText = Color(0xFFE89770);
  static const Color darkDialogOverlay = Color(0x8C000000);
  static const Color darkHomeIndicator = Color(0xFFE8E2D5);
  static const Color darkFabText = Color(0xFF1A1815);

  // OLED 鐪熼粦
  static const Color oledBlack = Color(0xFF000000);
}

class AppPalette {
  final Color bg;
  final Color text;
  final Color text2;
  final Color text3;
  final Color divider;
  final Color dividerStrong;
  final Color accent;
  final Color selectedBg;
  final Color selectedText;
  final Color chipBorder;
  final Color chipBorderActive;
  final Color inputBg;
  final Color inputPlaceholder;
  final Color highlightBg;
  final Color highlightText;
  final Color dialogOverlay;
  final Color homeIndicator;
  final Color fabText;

  const AppPalette({
    required this.bg,
    required this.text,
    required this.text2,
    required this.text3,
    required this.divider,
    required this.dividerStrong,
    required this.accent,
    required this.selectedBg,
    required this.selectedText,
    required this.chipBorder,
    required this.chipBorderActive,
    required this.inputBg,
    required this.inputPlaceholder,
    required this.highlightBg,
    required this.highlightText,
    required this.dialogOverlay,
    required this.homeIndicator,
    required this.fabText,
  });

  static const AppPalette light = AppPalette(
    bg: AppColors.lightBg,
    text: AppColors.lightText,
    text2: AppColors.lightText2,
    text3: AppColors.lightText3,
    divider: AppColors.lightDivider,
    dividerStrong: AppColors.lightDividerStrong,
    accent: AppColors.lightAccent,
    selectedBg: AppColors.lightSelectedBg,
    selectedText: AppColors.lightSelectedText,
    chipBorder: AppColors.lightChipBorder,
    chipBorderActive: AppColors.lightChipBorderActive,
    inputBg: AppColors.lightInputBg,
    inputPlaceholder: AppColors.lightInputPlaceholder,
    highlightBg: AppColors.lightHighlightBg,
    highlightText: AppColors.lightHighlightText,
    dialogOverlay: AppColors.lightDialogOverlay,
    homeIndicator: AppColors.lightHomeIndicator,
    fabText: AppColors.lightFabText,
  );

  static AppPalette dark({bool oled = false}) => AppPalette(
        bg: oled ? AppColors.oledBlack : AppColors.darkBg,
        text: AppColors.darkText,
        text2: AppColors.darkText2,
        text3: AppColors.darkText3,
        divider: AppColors.darkDivider,
        dividerStrong: AppColors.darkDividerStrong,
        accent: AppColors.darkAccent,
        selectedBg: AppColors.darkSelectedBg,
        selectedText: AppColors.darkSelectedText,
        chipBorder: AppColors.darkChipBorder,
        chipBorderActive: AppColors.darkChipBorderActive,
        inputBg: AppColors.darkInputBg,
        inputPlaceholder: AppColors.darkInputPlaceholder,
        highlightBg: AppColors.darkHighlightBg,
        highlightText: AppColors.darkHighlightText,
        dialogOverlay: AppColors.darkDialogOverlay,
        homeIndicator: AppColors.darkHomeIndicator,
        fabText: AppColors.darkFabText,
      );
}

class AppRadius {
  static const double phone = 56;
  static const double phoneInner = 44;
  static const double chip = 999;
  static const double card = 12;
  static const double input = 10;
  static const double aboutLogo = 16;
  static const double dialog = 14;
  static const double searchBox = 10;
}

class AppSpacing {
  static const double pageHPad = 24;
  static const double statusBarHeight = 54;
  static const double homeIndicatorW = 134;
  static const double homeIndicatorH = 5;
  static const double dynamicIslandW = 120;
  static const double dynamicIslandH = 35;
  static const double tabBarHeight = 84;
  static const double fabSize = 52;
  static const double fabBottom = 100;
}

extension AppPaletteAccess on BuildContext {
  AppPalette get palette {
    final ext = Theme.of(this).extension<AppPaletteExt>();
    return ext?.palette ?? AppPalette.light;
  }
}

class AppPaletteExt extends ThemeExtension<AppPaletteExt> {
  final AppPalette palette;
  const AppPaletteExt(this.palette);

  @override
  AppPaletteExt copyWith({AppPalette? palette}) =>
      AppPaletteExt(palette ?? this.palette);

  @override
  AppPaletteExt lerp(ThemeExtension<AppPaletteExt>? other, double t) {
    if (other is! AppPaletteExt) return this;
    return t < 0.5 ? this : other;
  }
}

ThemeData buildThemeData(AppPalette p) {
  final colorScheme = ColorScheme(
    brightness: p.bg.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
    primary: p.accent,
    onPrimary: p.fabText,
    secondary: p.accent,
    onSecondary: p.fabText,
    error: p.accent,
    onError: p.fabText,
    surface: p.bg,
    onSurface: p.text,
    surfaceContainerHighest: p.inputBg,
    outline: p.divider,
    outlineVariant: p.dividerStrong,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: p.bg,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    extensions: [AppPaletteExt(p)],
  );
}
