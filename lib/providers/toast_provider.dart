import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToastInfo {
  final String message;
  final String? undoLabel;
  final VoidCallback? onUndo;
  final int durationMs;
  final int key;
  const ToastInfo({
    required this.message,
    required this.key,
    this.undoLabel,
    this.onUndo,
    this.durationMs = 1800,
  });
}

typedef VoidCallback = void Function();

final toastProvider = StateProvider<ToastInfo?>((ref) => null);

void showToast(
  WidgetRef ref, {
  required String message,
  String? undoLabel,
  VoidCallback? onUndo,
  int durationMs = 1800,
}) {
  final key = DateTime.now().microsecondsSinceEpoch;
  ref.read(toastProvider.notifier).state = ToastInfo(
    message: message,
    undoLabel: undoLabel,
    onUndo: onUndo,
    durationMs: durationMs,
    key: key,
  );
  Future.delayed(Duration(milliseconds: durationMs), () {
    final cur = ref.read(toastProvider);
    if (cur != null && cur.key == key) {
      ref.read(toastProvider.notifier).state = null;
    }
  });
}

void hideToast(WidgetRef ref) {
  ref.read(toastProvider.notifier).state = null;
}
