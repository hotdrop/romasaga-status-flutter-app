import 'package:rsapp/romasaga/data/letter_repository.dart';
import 'package:rsapp/romasaga/model/letter.dart';
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
  void load() {
    run(
      label: "お便りのロード処理",
      block: () async {
        _letters = await _repository.findAll();
      },
    );
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
