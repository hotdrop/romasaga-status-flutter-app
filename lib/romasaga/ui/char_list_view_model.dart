import 'package:flutter/foundation.dart' as foundation;

import '../data/romasaga_repository.dart';
import '../model/character.dart';

class CharListViewModel extends foundation.ChangeNotifier {
  List<Character> _characters;
  RomasagaRepository repository;

  CharListViewModel({RomasagaRepository repo}) {
    repository = (repo == null) ? RomasagaRepository() : repo;
  }

  List<Character> findAll() {
    if (_characters == null) {
      return [];
    }

    return _characters;
  }

  void load() async {
    _characters = await repository.findAll();
    print('ViewModel load End! size=${_characters.length}');
    notifyListeners();
  }
}
