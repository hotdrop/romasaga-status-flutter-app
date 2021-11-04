import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/letter_repository.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/ui/base_view_model.dart';

final letterViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _LetterViewModel(ref.read));

class _LetterViewModel extends BaseViewModel {
  _LetterViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late List<Letter> _letters;
  bool get isEmpty => _letters.isEmpty;

  Future<void> _init() async {
    try {
      _letters = await _read(letterRepositoryProvider).findAll();
      onSuccess();
    } catch (e, s) {
      await RSLogger.e('お便り画面の初期化に失敗しました。', e, s);
      onError('$e');
    }
  }

  Future<void> refresh() async {
    try {
      await _read(letterRepositoryProvider).update();
      _letters = await _read(letterRepositoryProvider).findAll();
      notifyListeners();
    } catch (e, s) {
      await RSLogger.e('お便り画面の取得に失敗しました。', e, s);
      rethrow;
    }
  }

  List<Letter> findByYear(int year) {
    return _letters.where((letter) => letter.year == year).toList();
  }

  List<int> findDistinctYears() {
    Map<int, bool> m = {};
    for (Letter l in _letters) {
      m.putIfAbsent(l.year, () => true);
    }
    return m.keys.toList();
  }
}
