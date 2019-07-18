import 'package:flutter/foundation.dart' as foundation;

import '../data/romasaga_repository.dart';
import '../data/status_repository.dart';
import '../model/character.dart';

class CharListViewModel extends foundation.ChangeNotifier {
  final RomasagaRepository _romasagaRepository;
  final StatusRepository _statusRepository;

  List<Character> _characters;

  CharListViewModel({RomasagaRepository romasagaRepo, StatusRepository statusRepo})
      : _romasagaRepository = (romasagaRepo == null) ? RomasagaRepository() : romasagaRepo,
        _statusRepository = (statusRepo == null) ? StatusRepository() : statusRepo;

  List<Character> findAll() {
    if (_characters == null) {
      return [];
    }

    return _characters;
  }

  List<Character> findFavorite() {
    if (_characters == null) {
      return [];
    }

    final favoriteCharacters = _characters.where((character) => character.myStatus.favorite).toList();
    if (favoriteCharacters.isEmpty) {
      return [];
    }

    return favoriteCharacters;
  }

  List<Character> findHaveCharacter() {
    if (_characters == null) {
      return [];
    }

    final haveCharacters = _characters.where((character) => character.myStatus.have).toList();
    if (haveCharacters.isEmpty) {
      return [];
    }

    return haveCharacters;
  }

  List<Character> findNotHaveCharacter() {
    if (_characters == null) {
      return [];
    }

    final haveCharacters = _characters.where((character) => !character.myStatus.have).toList();
    if (haveCharacters.isEmpty) {
      return [];
    }

    return haveCharacters;
  }

  void load() async {
    _characters = await _romasagaRepository.findAll();
    final statusList = await _statusRepository.findAll();

    if (statusList.isNotEmpty) {
      statusList.forEach((status) {
        _characters.firstWhere((character) => character.name == status.charName).myStatus = status;
      });
    }

    notifyListeners();
  }
}
