import 'package:flutter/foundation.dart' as foundation;

import '../data/character_repository.dart';
import '../data/my_status_repository.dart';
import '../model/character.dart';

class CharListViewModel extends foundation.ChangeNotifier {
  final CharacterRepository _characterRepository;
  final MyStatusRepository _myStatusRepository;

  List<Character> _characters;

  CharListViewModel({CharacterRepository characterRepo, MyStatusRepository statusRepo})
      : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _myStatusRepository = (statusRepo == null) ? MyStatusRepository() : statusRepo;

  void load() async {
    _characters = await _characterRepository.findAll();
    final myStatuses = await _myStatusRepository.findAll();

    if (myStatuses.isNotEmpty) {
      for (var status in myStatuses) {
        final targetStatus = _characters.firstWhere((character) => character.id == status.id);
        targetStatus.myStatus = status;
      }
    }

    notifyListeners();
  }

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
}
