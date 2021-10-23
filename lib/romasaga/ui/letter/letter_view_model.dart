import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/letter_repository.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/romasaga/ui/change_notifier_view_model.dart';

class LetterViewModel extends ChangeNotifierViewModel {
  LetterViewModel._(this._repository);

  factory LetterViewModel.create() {
    return LetterViewModel._(LetterRepository.create());
  }

  List<Letter> _letters;
  final LetterRepository _repository;

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    nowLoading();

    try {
      _letters = await _repository.findAll();
      loadSuccess();
    } catch (e, s) {
      await RSLogger.e('お便り画面のロードに失敗しました。', e, s);
      loadError();
    }
  }

  bool get isEmpty => _letters.isEmpty;

  List<int> getDistinctYears() {
    Map<int, bool> m = {};
    for (Letter l in _letters) {
      m.putIfAbsent(l.year, () => true);
    }
    return m.keys.toList();
  }

  List<Letter> letterByYear(int year) {
    return _letters.where((letter) => letter.year == year).toList();
  }
}
