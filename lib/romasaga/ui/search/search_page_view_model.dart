import 'package:flutter/foundation.dart' as foundation;

import '../../data/character_repository.dart';
import '../../data/my_status_repository.dart';

import '../../model/character.dart';
import '../../model/search_condition.dart';
import '../../model/weapon.dart';

import '../../common/rs_logger.dart';

class SearchPageViewModel extends foundation.ChangeNotifier {
  SearchPageViewModel._(this._characterRepository, this._myStatusRepository);

  factory SearchPageViewModel.create() {
    return SearchPageViewModel._(
      CharacterRepository.create(),
      MyStatusRepository.create(),
    );
  }

  CharacterRepository _characterRepository;
  MyStatusRepository _myStatusRepository;

  List<Character> _originalCharacters;
  List<Character> charactersWithFilter;

  SearchCondition _condition = SearchCondition();

  _PageState _pageState = _PageState.loading;
  bool get isLoading => _pageState == _PageState.loading;
  bool get isSuccess => _pageState == _PageState.success;
  bool get isError => _pageState == _PageState.error;

  bool isKeywordSearch = false;

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    _pageState = _PageState.loading;
    notifyListeners();

    try {
      final characters = await _characterRepository.findAll();
      final charactersWithMyStatus = await _loadMyStatuses(characters);

      _originalCharacters = charactersWithMyStatus;
      charactersWithFilter = charactersWithMyStatus;

      _pageState = _PageState.success;
      notifyListeners();
    } catch (e) {
      RSLogger.e("キャラ情報ロード時にエラーが発生しました。", e);
      _pageState = _PageState.error;
      notifyListeners();
    }
  }

  Future<List<Character>> _loadMyStatuses(List<Character> argCharacters) async {
    final characters = argCharacters;
    final myStatuses = await _myStatusRepository.findAll();

    RSLogger.d("詳細なステータスをロードします。");
    if (myStatuses.isNotEmpty) {
      for (var status in myStatuses) {
        characters.firstWhere((character) => character.id == status.id).myStatus = status;
      }
    }

    return characters;
  }

  void tapSearchIcon() {
    if (isKeywordSearch) {
      RSLogger.d("キーワード検索を終了します。");
      isKeywordSearch = false;
      _condition.keyword = null;
      clear();
    } else {
      RSLogger.d("キーワード検索を開始します。");
      isKeywordSearch = true;
      notifyListeners();
    }
  }

  bool isFilterHave() {
    return _condition.haveChar;
  }

  bool isFilterFavorite() {
    return _condition.isFavorite;
  }

  bool isSelectWeaponType(WeaponType type) {
    return type == _condition.weaponType;
  }

  void clear() {
    charactersWithFilter = _originalCharacters;
    notifyListeners();
  }

  void findByKeyword(String word) {
    _condition.keyword = word;
    RSLogger.d("$word を検索します。");
    _search();
  }

  void findByWeaponType(WeaponType type) {
    RSLogger.d("${type.name} をフィルター指定します。");
    _condition.weaponType = type;
    _search();
  }

  void filterHaveChar(bool haveChar) {
    _condition.haveChar = haveChar;
    _search();
  }

  void filterFavorite(bool favorite) {
    _condition.isFavorite = favorite;
    _search();
  }

  void _search() {
    charactersWithFilter = _originalCharacters
        .where((c) => _condition.filterWord(targetName: c.name, targetProduction: c.production))
        .where((c) => _condition.filterHave(c.myStatus.have))
        .where((c) => _condition.filterFavorite(c.myStatus.favorite))
        .where((c) => _condition.filterWeaponType(c.weaponType))
        .toList();
    RSLogger.d("フィルター後のキャラ数=${charactersWithFilter.length}");
    notifyListeners();
  }
}

enum _PageState { loading, success, error }
