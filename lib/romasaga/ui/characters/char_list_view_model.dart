import 'package:flutter/foundation.dart' as foundation;

import '../../data/character_repository.dart';
import '../../data/my_status_repository.dart';

import '../../model/character.dart';
import '../../model/weapon.dart';

import '../../common/rs_logger.dart';

class CharListViewModel extends foundation.ChangeNotifier {
  CharListViewModel._(this._characterRepository, this._myStatusRepository);

  factory CharListViewModel.create() {
    return CharListViewModel._(CharacterRepository(), MyStatusRepository());
  }

  factory CharListViewModel.test(CharacterRepository characterRepo, MyStatusRepository statusRepo) {
    return CharListViewModel._(characterRepo, statusRepo);
  }

  final CharacterRepository _characterRepository;
  final MyStatusRepository _myStatusRepository;

  List<Character> _characters;
  OrderType selectedOrderType = OrderType.status;

  _PageState _pageState = _PageState.loading;

  bool get isLoading => _pageState == _PageState.loading;
  bool get isSuccess => _pageState == _PageState.success;
  bool get isError => _pageState == _PageState.error;

  Future<void> load() async {
    await refreshCharacters();
  }

  Future<void> refreshCharacters() async {
    _pageState = _PageState.loading;
    notifyListeners();

    try {
      _characters = await _characterRepository.load();
      await _loadMyStatuses();
      _pageState = _PageState.success;

      orderBy(OrderType.status);
    } catch (e) {
      RSLogger.e("キャラ情報ロード時にエラーが発生しました。", e);
      _pageState = _PageState.error;
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

  void orderBy(OrderType order) {
    switch (order) {
      case OrderType.weapon:
        _characters.sort((c1, c2) => _compareWeapon(c1.weaponType, c2.weaponType));
        break;
      default:
        _characters.sort((c1, c2) => c2.getTotalStatus().compareTo(c1.getTotalStatus()));
        break;
    }
    selectedOrderType = order;
    notifyListeners();
  }

  ///
  /// 自身のステータス情報を更新する。
  /// 通常、自身のステータスはロード時に持ってきて以降は更新処理がいちいち走るのでこのメソッドは不要。
  /// ただ、アカウント画面で自身のステータス情報を復元した場合のみリフレッシュが必要なのでこれを用意している。
  ///
  Future<void> refreshMyStatuses() async {
    await _loadMyStatuses();
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

enum OrderType { status, weapon }
enum _PageState { loading, success, error }
