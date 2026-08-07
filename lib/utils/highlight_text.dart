import 'package:flutter/material.dart';

/// 鎶?query 鍦?text 閲屽嚭鐜扮殑瀛愪覆鐢?highlightStyle 娓叉煋锛屽叾浣欐寜 baseStyle 娓叉煋
TextSpan buildHighlightSpan(
  String text,
  String query, {
  required TextStyle baseStyle,
  required TextStyle highlightStyle,
}) {
  if (query.isEmpty) return TextSpan(text: text, style: baseStyle);
  final spans = <TextSpan>[];
  final lower = text.toLowerCase();
  final q = query.toLowerCase();
  int i = 0;
  while (i < text.length) {
    final hit = lower.indexOf(q, i);
    if (hit < 0) {
      spans.add(TextSpan(text: text.substring(i), style: baseStyle));
      break;
    }
    if (hit > i) {
      spans.add(TextSpan(text: text.substring(i, hit), style: baseStyle));
    }
    spans.add(TextSpan(
      text: text.substring(hit, hit + q.length),
      style: highlightStyle,
    ));
    i = hit + q.length;
  }
  return TextSpan(children: spans);
}
