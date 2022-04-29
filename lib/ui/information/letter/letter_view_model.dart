import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/letter_repository.dart';
import 'package:rsapp/models/letter.dart';

// お便りデータ
final lettersStateProvider = StateNotifierProvider<_LetterStateNotifier, AsyncValue<List<Letter>>>((ref) {
  return _LetterStateNotifier(ref.read);
});

class _LetterStateNotifier extends StateNotifier<AsyncValue<List<Letter>>> {
  _LetterStateNotifier(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _read(letterRepositoryProvider).findAll());
  }

  Future<void> refresh() async {
    await _read(letterRepositoryProvider).update();
    state = await AsyncValue.guard(() async => await _read(letterRepositoryProvider).findAll());
  }
}

// お便り一覧から年情報を取得する
final lettersExtractYears = Provider.family<List<int>, List<Letter>>((ref, letters) {
  Map<int, bool> m = {};
  for (Letter l in letters) {
    m.putIfAbsent(l.year, () => true);
  }
  return m.keys.toList();
});
