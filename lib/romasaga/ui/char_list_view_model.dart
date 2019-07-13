import 'package:flutter/foundation.dart' as foundation;

import '../data/romasaga_repository.dart';
import '../model/character.dart';

class CharListViewModel extends foundation.ChangeNotifier {
  final RomasagaRepository _repository;

  List<Character> _characters;

  CharListViewModel({RomasagaRepository repo}) : _repository = (repo == null) ? RomasagaRepository() : repo;

  List<Character> findAll() {
    if (_characters == null) {
      return [];
    }

    return _characters;
  }

  void load() async {
    _characters = await _repository.findAll();
    // TODO mystatusもここで取得して合体させる
    notifyListeners();
  }
}
