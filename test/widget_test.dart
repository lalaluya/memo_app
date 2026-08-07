import 'package:flutter_test/flutter_test.dart';
import 'package:memo_app/data/models/memo.dart';

void main() {
  test('Memo preview 截取 body 前 80 字', () {
    final m = Memo(
      title: 't',
      body: 'A' * 100,
      tag: '日常',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    expect(m.preview.length, 81); // 80 个 A + '…'
  });

  test('Memo fromMap/toMap 往返一致', () {
    final now = DateTime(2024, 1, 2, 3, 4);
    final m = Memo(
      id: 1,
      title: 't',
      body: 'b',
      tag: '日常',
      createdAt: now,
      updatedAt: now,
    );
    final map = m.toMap();
    final m2 = Memo.fromMap(map);
    expect(m2.id, m.id);
    expect(m2.title, m.title);
    expect(m2.body, m.body);
    expect(m2.tag, m.tag);
    expect(m2.createdAt, m.createdAt);
    expect(m2.updatedAt, m.updatedAt);
  });
}
