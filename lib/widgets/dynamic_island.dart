import 'package:flutter/material.dart';

class DynamicIsland extends StatelessWidget {
  const DynamicIsland({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 11,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 120,
          height: 35,
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
