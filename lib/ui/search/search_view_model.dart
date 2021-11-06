import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/production.dart';
import 'package:rsapp/models/search_condition.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/ui/base_view_model.dart';

final searchViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _SearchViewModel(ref.read));

class _SearchViewModel extends BaseViewModel {
  _SearchViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late List<Character> _characters;
  late List<Character> charactersWithFilter;
  final SearchCondition _condition = SearchCondition();
  bool isKeywordSearch = false;

  Future<void> _init() async {
    try {
      await _read(characterNotifierProvider.notifier).refresh();
      _characters = _read(characterNotifierProvider);
      charactersWithFilter = _characters;
      onSuccess();
    } catch (e, s) {
      await RSLogger.e('検索画面のロードに失敗しました。', e, s);
      onError('$e');
    }
  }

  void changeSearchMode() {
    if (isKeywordSearch) {
      isKeywordSearch = false;
      _condition.keyword = null;
      _search();
    } else {
      isKeywordSearch = true;
      notifyListeners();
    }
  }

  bool isFilterFavorite() {
    return _condition.isFavorite;
  }

  bool isSelectWeaponType(WeaponType type) {
    return type == _condition.weaponType;
  }

  bool isSelectAttributeType(AttributeType type) {
    return type == _condition.attributeType;
  }

  bool isSelectProductType(ProductionType type) {
    return type == _condition.productionType;
  }

  void findByKeyword(String word) {
    _condition.keyword = word;
    _search();
  }

  void filterFavorite(bool favorite) {
    _condition.isFavorite = favorite;
    _search();
  }

  void findByWeaponType(WeaponType type) {
    _condition.weaponType = type;
    _search();
  }

  void findByAttributeType(AttributeType type) {
    _condition.attributeType = type;
    _search();
  }

  void findByProduction(ProductionType type) {
    _condition.productionType = type;
    _search();
  }

  void clearFilterWeapon() {
    _condition.weaponType = null;
    _search();
  }

  void clearFilterAttribute() {
    _condition.attributeType = null;
    _search();
  }

  void clearFilterProduction() {
    _condition.productionType = null;
    _search();
  }

  void _search() {
    charactersWithFilter = _characters
        .where((c) => _condition.filterWord(targetName: c.name, targetProduction: c.production))
        .where((c) => _condition.filterFavorite(c.myStatus?.favorite ?? false))
        .where((c) => _condition.filterWeaponType(c.weapon))
        .where((e) => _condition.filterAttributesType(e.attributes))
        .where((e) => _condition.filterProductionType(e.production))
        .toList();
    RSLogger.d('フィルター後のキャラ数=${charactersWithFilter.length}');
    notifyListeners();
  }
}
