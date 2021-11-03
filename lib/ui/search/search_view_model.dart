import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/production.dart';
import 'package:rsapp/models/search_condition.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:collection/collection.dart';

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
      // TODO ここstatenotifierにしたほうがいい
      final characters = await _read(characterRepositoryProvider).findAll();
      final myStatuses = await _read(myStatusRepositoryProvider).findAll();
      _characters = await _merge(characters, myStatuses);
      charactersWithFilter = _characters;
      onSuccess();
    } catch (e, s) {
      await RSLogger.e('検索画面のロードに失敗しました。', e, s);
      onError('$e');
    }
  }

  // characters_view_modelと全く同じなのでStateNotifierにする
  Future<List<Character>> _merge(List<Character> characters, List<MyStatus> statues) async {
    if (statues.isNotEmpty) {
      RSLogger.d('登録ステータス${statues.length}件をキャラ情報にマージします。');
      List<Character> newCharacters = [];
      for (var c in characters) {
        final status = statues.firstWhereOrNull((s) => s.id == c.id);
        if (status != null) {
          newCharacters.add(c.withStatus(status));
        } else {
          newCharacters.add(c);
        }
      }
      return newCharacters;
    } else {
      RSLogger.d('登録ステータスは0件です。');
      return characters;
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
