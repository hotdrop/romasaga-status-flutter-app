import 'package:flutter/foundation.dart' as foundation;

import '../data/character_repository.dart';
import '../data/my_status_repository.dart';

import '../model/character.dart';
import '../model/weapon.dart';

import '../common/rs_logger.dart';
import 'view_state.dart';

class CharListViewModel extends foundation.ChangeNotifier with ViewState {
  final CharacterRepository _characterRepository;
  final MyStatusRepository _myStatusRepository;

  List<Character> _characters;
  OrderType selectedOrderType = OrderType.none;

  CharListViewModel({CharacterRepository characterRepo, MyStatusRepository statusRepo})
      : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _myStatusRepository = (statusRepo == null) ? MyStatusRepository() : statusRepo;

  void load() async {
    refreshCharacters();
  }

  void refreshCharacters() async {
    onLoading();
    notifyListeners();

    try {
      _characters = await _characterRepository.load();
      _loadMyStatuses();
      // 初期の並び順はステータスにする
      orderBy(OrderType.status);

      onSuccess();
      notifyListeners();
    } catch (e) {
      RSLogger.e("キャラ情報ロード時にエラー", e);
      onError();
      notifyListeners();
    }
  }

  List<Character> findAll() {
    return _characters;
  }

  List<Character> findFavorite() {
    final favoriteCharacters = _characters.where((character) => character.myStatus.favorite).toList();
    return favoriteCharacters.isEmpty ? [] : favoriteCharacters;
  }

  List<Character> findHaveCharacter() {
    final haveCharacters = _characters.where((character) => character.myStatus.have).toList();
    return haveCharacters.isEmpty ? [] : haveCharacters;
  }

  List<Character> findNotHaveCharacter() {
    final haveCharacters = _characters.where((character) => !character.myStatus.have).toList();
    return haveCharacters.isEmpty ? [] : haveCharacters;
  }

  void orderBy(OrderType type) {
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
    selectedOrderType = type;
    notifyListeners();
  }

  ///
  /// 自身のステータス情報を更新する。
  /// 通常、自身のステータスはロード時に持ってきて以降は更新処理がいちいち走るのでこのメソッドは不要。
  /// ただ、アカウント画面で自身のステータス情報を復元した場合のみリフレッシュが必要なのでこれを用意している。
  ///
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
