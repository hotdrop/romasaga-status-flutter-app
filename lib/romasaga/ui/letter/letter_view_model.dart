import 'package:flutter/foundation.dart' as foundation;
import 'package:rsapp/romasaga/data/letter_repository.dart';
import 'package:rsapp/romasaga/model/letter.dart';

class LetterViewModel extends foundation.ChangeNotifier {
  LetterViewModel._(this._repository);

  factory LetterViewModel.create() {
    return LetterViewModel._(LetterRepository.create());
  }

  List<Letter> letters;
  final LetterRepository _repository;
  _PageState _pageState = _PageState.loading;

  bool get isLoading => _pageState == _PageState.loading;
  bool get isLoaded => _pageState == _PageState.loaded;
  bool get isError => _pageState == _PageState.error;

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    _pageState = _PageState.loading;
    notifyListeners();

    try {
      letters = await _repository.findAll();
    } catch (e) {
      _pageState = _PageState.error;
      notifyListeners();
      return;
    }

    _pageState = _PageState.loaded;
    notifyListeners();
  }
}

enum _PageState { loading, loaded, error }
