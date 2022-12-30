import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/letter_repository.dart';
import 'package:rsapp/models/letter.dart';

// お便りデータ
final lettersStateProvider = StateNotifierProvider.autoDispose<_LetterStateNotifier, AsyncValue<List<Letter>>>((ref) {
  return _LetterStateNotifier(ref);
});

class _LetterStateNotifier extends StateNotifier<AsyncValue<List<Letter>>> {
  _LetterStateNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref _ref;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _ref.read(letterRepositoryProvider).findAll());
  }

  Future<void> refresh() async {
    await _ref.read(letterRepositoryProvider).update();
    state = await AsyncValue.guard(() async => await _ref.read(letterRepositoryProvider).findAll());
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
