import 'package:flutter/foundation.dart' as foundation;

import '../data/romasaga_repository.dart';
import '../model/character.dart';

class CharListViewModel extends foundation.ChangeNotifier {
  List<Character> _characters;
  RomasagaRepository _repository;

  CharListViewModel({RomasagaRepository repo}) {
    _repository = (repo == null) ? RomasagaRepository() : repo;
  }

  List<Character> findAll() {
    if (_characters == null) {
      return [];
    }

    return _characters;
  }

  void load() async {
    _characters = await _repository.findAll();
    notifyListeners();
  }
}
