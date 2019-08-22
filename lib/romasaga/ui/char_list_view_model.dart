import 'package:flutter/foundation.dart' as foundation;

import '../data/character_repository.dart';
import '../data/my_status_repository.dart';
import '../model/character.dart';
import '../model/weapon.dart';

class CharListViewModel extends foundation.ChangeNotifier {
  final CharacterRepository _characterRepository;
  final MyStatusRepository _myStatusRepository;

  List<Character> _characters;

  CharListViewModel({CharacterRepository characterRepo, MyStatusRepository statusRepo})
      : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _myStatusRepository = (statusRepo == null) ? MyStatusRepository() : statusRepo;

  void load() async {
    refreshCharacters();
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

  void orderBy(OrderType type) {
    if (_characters == null) {
      return;
    }

    switch (type) {
      case OrderType.status:
        _characters.sort((c1, c2) => c2.getTotalStatus().compareTo(c1.getTotalStatus()));
        break;
      case OrderType.weapon:
        _characters.sort((c1, c2) => _compareWeapon(c1.weaponType, c2.weaponType));
        break;
      case OrderType.none:
        _characters.sort((c1, c2) => c1.id.compareTo(c2.id));
        break;
    }
    notifyListeners();
  }

  void refreshCharacters() async {
    _characters = await _characterRepository.load();
    _loadMyStatuses();
    notifyListeners();
  }

  void refreshMyStatuses() async {
    _loadMyStatuses();
    notifyListeners();
  }

  Future<void> _loadMyStatuses() async {
    final myStatuses = await _myStatusRepository.findAll();

    if (myStatuses.isNotEmpty) {
      for (var status in myStatuses) {
        final targetStatus = _characters.firstWhere((character) => character.id == status.id);
        targetStatus.myStatus = status;
      }
    }
  }

  int _compareWeapon(WeaponType c1, WeaponType c2) {
    final c1SortNo = c1.sortOrder();
    final c2SortNo = c2.sortOrder();
    if (c1SortNo > c2SortNo) {
      return 1;
    } else if (c1SortNo == c2SortNo) {
      return 0;
    } else {
      return -1;
    }
  }
}

enum OrderType { status, weapon, none }
