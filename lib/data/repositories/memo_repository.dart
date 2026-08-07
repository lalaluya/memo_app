import '../db/memo_database.dart';
import '../models/memo.dart';

class MemoRepository {
  MemoRepository(this._db);
  final MemoDatabase _db;

  Future<List<Memo>> all() => _db.all();
  Future<Memo?> byId(int id) => _db.byId(id);
  Future<List<Memo>> search(String q) => _db.search(q);

  Future<int> create(Memo m) async {
    final id = await _db.insert(m);
    return id;
  }

  Future<void> update(Memo m) => _db.update(m);
  Future<void> delete(int id) => _db.delete(id);
}
