import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/memo.dart';

class MemoDatabase {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'memo_app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE memos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, body TEXT NOT NULL, tag TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)');
        await db.execute('CREATE INDEX idx_memos_updated_at ON memos(updated_at DESC)');
        await _seed(db);
      },
    );
    return _db!;
  }

  static Future<void> _seed(Database db) async {
    final seeds = <Map<String, Object?>>[
      {
        'title': '雨后的柏油路',
        'body':
            '下了一整夜的雨，清早出门时路面还没干透。空气里混着泥土和树叶的味道，光透过云层打下来，世界像被洗过一样。\n走到巷口的时候，低头看见自己的影子。很长很清晰。',
        'tag': '日常',
        'created_at':
            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7, 42).millisecondsSinceEpoch,
      },
      {
        'title': '关于"等待"',
        'body':
            '等一壶水开，等一个人回消息，等雨停。等的时候，时间不是流逝的，是一颗悬着的心。',
        'tag': '随想',
        'created_at':
            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1, 22, 18)
                .millisecondsSinceEpoch,
      },
      {
        'title': '读到的一段话',
        'body':
            '"我们很少信任比我们好的人，宁愿避免与他们来往。相反，我们常对与我们相似、和我们有着共同弱点的人吐露心迹。"\n\n—— 加缪《局外人》',
        'tag': '摘录',
        'created_at':
            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 2, 16, 30)
                .millisecondsSinceEpoch,
      },
      {
        'title': '父亲的旧钢笔',
        'body':
            '翻抽屉时找到的。笔尖已经钝了，但还有墨水。握在手里，是父亲年轻时的手感。\n记得他写字时会把笔尖朝下甩两下，墨水有时会甩在白衬衣上。他不介意，说说这这才叫"手写"。',
        'tag': '随想',
        'created_at':
            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 3, 23, 55)
                .millisecondsSinceEpoch,
      },
      {
        'title': '明天的清单',
        'body': '一、给阳台的花浇个水。\n二、给妈妈打个电话。\n三、买一本新的笔记本。',
        'tag': '待办',
        'created_at':
            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 4, 22, 1)
                .millisecondsSinceEpoch,
      },
    ];
    for (final s in seeds) {
      s['updated_at'] = s['created_at'];
      await db.insert('memos', s);
    }
  }

  Future<List<Memo>> all() async {
    final db = await instance;
    final rows = await db.query('memos', orderBy: 'updated_at DESC');
    return rows.map(Memo.fromMap).toList();
  }

  Future<Memo?> byId(int id) async {
    final db = await instance;
    final rows = await db.query('memos', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Memo.fromMap(rows.first);
  }

  Future<int> insert(Memo memo) async {
    final db = await instance;
    return db.insert('memos', memo.toMap());
  }

  Future<int> update(Memo memo) async {
    final db = await instance;
    return db.update('memos', memo.toMap(),
        where: 'id = ?', whereArgs: [memo.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance;
    return db.delete('memos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Memo>> search(String q) async {
    if (q.trim().isEmpty) return [];
    final db = await instance;
    final rows = await db.query(
      'memos',
      where: 'title LIKE ? OR body LIKE ? OR tag LIKE ?',
      whereArgs: ['%$q%', '%$q%', '%$q%'],
      orderBy: 'updated_at DESC',
    );
    return rows.map(Memo.fromMap).toList();
  }
}