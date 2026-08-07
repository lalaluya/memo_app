import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/memo_database.dart';
import '../data/models/memo.dart';
import '../data/repositories/memo_repository.dart';

final memoRepositoryProvider =
    Provider<MemoRepository>((ref) => MemoRepository(MemoDatabase()));

final memosProvider =
    StateNotifierProvider<MemosNotifier, AsyncValue<List<Memo>>>((ref) {
  final repo = ref.watch(memoRepositoryProvider);
  return MemosNotifier(repo);
});

class MemosNotifier extends StateNotifier<AsyncValue<List<Memo>>> {
  MemosNotifier(this._repo) : super(const AsyncValue.loading()) {
    _init();
  }
  final MemoRepository _repo;

  Future<void> _init() async {
    try {
      final list = await _repo.all();
      state = AsyncValue.data(list);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> refresh() async {
    final list = await _repo.all();
    state = AsyncValue.data(list);
  }

  Future<int> create(Memo m) async {
    final id = await _repo.create(m);
    await refresh();
    return id;
  }

  Future<void> update(Memo m) async {
    await _repo.update(m);
    await refresh();
  }

  Future<void> delete(int id) async {
    await _repo.delete(id);
    await refresh();
  }

  /// 鎶婂凡鍒犻櫎鐨?memo 鎻掑洖鍒楄〃澶撮儴
  Future<void> restore(Memo m, {int? newId}) async {
    final id = await _repo.create(m);
    await refresh();
  }

  Future<List<Memo>> search(String q) => _repo.search(q);
}

final memoByIdProvider = Provider.family<Memo?, int>((ref, id) {
  final list = ref.watch(memosProvider).asData?.value ?? const [];
  for (final m in list) {
    if (m.id == id) return m;
  }
  return null;
});

final activeTagProvider = StateProvider<String?>((ref) => null);

final filteredMemosProvider = Provider<AsyncValue<List<Memo>>>((ref) {
  final all = ref.watch(memosProvider);
  final tag = ref.watch(activeTagProvider);
  return all.whenData((list) {
    if (tag == null) return list;
    return list.where((m) => m.tag == tag).toList();
  });
});

