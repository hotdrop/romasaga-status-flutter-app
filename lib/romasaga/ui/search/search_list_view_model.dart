import 'package:flutter/foundation.dart' as foundation;

import '../../model/character.dart';
import '../../model/search_condition.dart';
import '../../model/weapon.dart';

import '../../common/rs_logger.dart';

class SearchListViewModel extends foundation.ChangeNotifier {
  List<Character> _originalCharacters;
  List<Character> charactersWithFilter;

  SearchCondition _condition = SearchCondition();

  bool isKeywordSearch = false;

  SearchListViewModel(this._originalCharacters) : charactersWithFilter = _originalCharacters;

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

  void findByKeyword(String word) async {
    _condition.keyword = word;
    RSLogger.d("$word を検索します。");
    _search();
  }

  void findByWeaponType(WeaponType type) async {
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
        .where((c) => _condition.filterWord(c.name))
        .where((c) => _condition.filterHave(c.myStatus.have))
        .where((c) => _condition.filterFavorite(c.myStatus.favorite))
        .where((c) => _condition.filterWeaponType(c.weaponType))
        .toList();
    RSLogger.d("フィルター後のキャラ数=${charactersWithFilter.length}");
    notifyListeners();
  }
}
