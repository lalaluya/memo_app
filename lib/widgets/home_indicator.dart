import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HomeIndicator extends StatelessWidget {
  const HomeIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: AppSpacing.homeIndicatorW,
          height: AppSpacing.homeIndicatorH,
          decoration: BoxDecoration(
            color: p.homeIndicator,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
