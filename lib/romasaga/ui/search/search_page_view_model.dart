import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/character_repository.dart';
import 'package:rsapp/romasaga/data/my_status_repository.dart';
import 'package:rsapp/romasaga/model/attribute.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/production.dart';
import 'package:rsapp/romasaga/model/search_condition.dart';
import 'package:rsapp/romasaga/model/weapon.dart';
import 'package:rsapp/romasaga/ui/change_notifier_view_model.dart';

class SearchPageViewModel extends ChangeNotifierViewModel {
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

  bool isKeywordSearch = false;

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    nowLoading();

    try {
      final characters = await _characterRepository.findAll();
      final charactersWithMyStatus = await _loadMyStatuses(characters);

      _originalCharacters = charactersWithMyStatus;
      charactersWithFilter = charactersWithMyStatus;
      loadSuccess();
    } catch (e, s) {
      await RSLogger.e('検索画面のロードに失敗しました。', e, s);
      loadError();
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

  bool isSelectAttributeType(AttributeType type) {
    return type == _condition.attributeType;
  }

  bool isSelectProductType(ProductionType type) {
    return type == _condition.productionType;
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

  void filterHaveChar(bool haveChar) {
    _condition.haveChar = haveChar;
    _search();
  }

  void filterFavorite(bool favorite) {
    _condition.isFavorite = favorite;
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
    charactersWithFilter = _originalCharacters
        .where((c) => _condition.filterWord(targetName: c.name, targetProduction: c.production))
        .where((c) => _condition.filterHave(c.myStatus.have))
        .where((c) => _condition.filterFavorite(c.myStatus.favorite))
        .where((c) => _condition.filterWeaponType(c.weapon))
        .where((e) => _condition.filterAttributesType(e.attributes))
        .where((e) => _condition.filterProductionType(e.production))
        .toList();
    RSLogger.d("フィルター後のキャラ数=${charactersWithFilter.length}");
    notifyListeners();
  }
}
