import 'package:flutter/foundation.dart';

@immutable
class Memo {
  final int? id;
  final String title;
  final String body;
  final String tag;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Memo({
    this.id,
    required this.title,
    required this.body,
    required this.tag,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns the first 80 chars of body as a preview.
  String get preview {
    final cleaned = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (cleaned.length <= 80) return cleaned;
    return '${cleaned.substring(0, 80)}…';
  }

  /// Original prototype displayed "M月D日 · HH:MM".
  String get displayDate {
    final m = createdAt.month.toString();
    final d = createdAt.day.toString();
    final hh = createdAt.hour.toString().padLeft(2, '0');
    final mm = createdAt.minute.toString().padLeft(2, '0');
    return '$m月$d日 · $hh:$mm';
  }

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'body': body,
        'tag': tag,
        'created_at': createdAt.millisecondsSinceEpoch,
        'updated_at': updatedAt.millisecondsSinceEpoch,
      };

  factory Memo.fromMap(Map<String, Object?> m) => Memo(
        id: m['id'] as int?,
        title: (m['title'] as String?) ?? '',
        body: (m['body'] as String?) ?? '',
        tag: (m['tag'] as String?) ?? '日常',
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            (m['created_at'] as int?) ?? 0),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
            (m['updated_at'] as int?) ?? 0),
      );

  Memo copyWith({
    int? id,
    String? title,
    String? body,
    String? tag,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Memo(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        tag: tag ?? this.tag,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Memo &&
          other.id == id &&
          other.title == title &&
          other.body == body &&
          other.tag == tag;

  @override
  int get hashCode => Object.hash(id, title, body, tag);
}