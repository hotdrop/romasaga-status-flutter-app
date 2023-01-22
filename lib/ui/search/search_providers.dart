import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/production.dart';
import 'package:rsapp/models/weapon.dart';

part 'search_providers.g.dart';

@riverpod
class SearchController extends _$SearchController {
  @override
  void build() {}

  void changeSearchMode() {
    if (ref.read(_uiStateProvider).isKeywordSearch) {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWithClear(
            isKeywordSearch: false,
            keyword: true,
          ));
    } else {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(isKeywordSearch: true));
    }
  }

  void findByKeyword(String word) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(keyword: word));
  }

  void filterCategory({required bool favorite, required bool highLevel, required bool around}) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(isFavorite: favorite, isUseHighLevel: highLevel, isUseAround: around));
  }

  void findByWeaponType(WeaponType type) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(weaponType: type));
  }

  void findByAttributeType(AttributeType type) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(attributeType: type));
  }

  void findByProduction(ProductionType type) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(productionType: type));
  }

  void clearFilterWeapon() {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWithClear(weaponType: true));
  }

  void clearFilterAttribute() {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWithClear(attributeType: true));
  }

  void clearFilterProduction() {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWithClear(productionType: true));
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  _UiState({
    required this.isKeywordSearch,
    this.keyword,
    this.weaponType,
    this.attributeType,
    this.productionType,
    this.isFavorite = false,
    this.isUseHighLevel = false,
    this.isUseAround = false,
  });

  factory _UiState.empty() {
    return _UiState(isKeywordSearch: false);
  }

  final bool isKeywordSearch;
  final String? keyword;
  final WeaponType? weaponType;
  final AttributeType? attributeType;
  final ProductionType? productionType;
  final bool isFavorite;
  final bool isUseHighLevel;
  final bool isUseAround;

  ///
  /// キーワードフィルター
  ///
  bool filterWord({required String targetName, required String targetProduction}) {
    if (keyword == null) {
      return true;
    }
    return targetName.contains(keyword!) || targetProduction.contains(keyword!);
  }

  ///
  /// カテゴリーフィルター
  ///
  bool filterCategory(bool characterFav, bool characterIsHighLevel) {
    if (isFavorite) {
      return characterFav;
    }

    if (isUseHighLevel) {
      return characterFav && characterIsHighLevel;
    }

    if (isUseAround) {
      return characterFav && !characterIsHighLevel;
    }

    // どのフィルターもかかっていない場合はフィルターかけない
    return true;
  }

  ///
  /// 武器種別でのフィルタ
  ///
  bool filterWeaponType(List<Weapon> weapon) {
    if (weaponType == null) {
      return true;
    }
    return weapon.any((w) => w.type == weaponType);
  }

  ///
  /// 属性でのフィルタ
  ///
  bool filterAttributesType(List<Attribute>? attributes) {
    if (attributeType == null) {
      return true;
    }
    if (attributes == null) {
      return false;
    }

    return attributes.any((a) => a.type == attributeType);
  }

  ///
  /// 作品でのフィルタ
  ///
  bool filterProductionType(String name) {
    if (productionType == null) {
      return true;
    }
    return Production.equal(productionType!, name);
  }

  ///
  /// nullは絞り込みクリアと同義なのでcopyWithで初期化できない。
  /// そのため絞り込みをクリアするためのclearメソッドを別途設ける
  ///
  _UiState copyWithClear({
    bool? isKeywordSearch,
    bool keyword = false,
    bool weaponType = false,
    bool attributeType = false,
    bool productionType = false,
  }) {
    return _UiState(
      isKeywordSearch: isKeywordSearch ?? this.isKeywordSearch,
      keyword: keyword ? null : this.keyword,
      weaponType: weaponType ? null : this.weaponType,
      attributeType: attributeType ? null : this.attributeType,
      productionType: productionType ? null : this.productionType,
      isFavorite: isFavorite,
      isUseHighLevel: isUseHighLevel,
      isUseAround: isUseAround,
    );
  }

  _UiState copyWith({
    bool? isKeywordSearch,
    String? keyword,
    WeaponType? weaponType,
    AttributeType? attributeType,
    ProductionType? productionType,
    bool? isFavorite,
    bool? isUseHighLevel,
    bool? isUseAround,
  }) {
    return _UiState(
      isKeywordSearch: isKeywordSearch ?? this.isKeywordSearch,
      keyword: keyword ?? this.keyword,
      weaponType: weaponType ?? this.weaponType,
      attributeType: attributeType ?? this.attributeType,
      productionType: productionType ?? this.productionType,
      isFavorite: isFavorite ?? this.isFavorite,
      isUseHighLevel: isUseHighLevel ?? this.isUseHighLevel,
      isUseAround: isUseAround ?? this.isUseAround,
    );
  }
}

// 検索結果のキャラ一覧
final searchCharacterProvider = Provider<List<Character>>((ref) {
  final uiState = ref.watch(_uiStateProvider);
  return ref
      .watch(characterProvider)
      .where((c) => uiState.filterWord(targetName: c.name, targetProduction: c.production))
      .where((c) => uiState.filterCategory(c.myStatus?.favorite ?? false, c.myStatus?.useHighLevel ?? false))
      .where((c) => uiState.filterWeaponType(c.weapons))
      .where((e) => uiState.filterAttributesType(e.attributes))
      .where((e) => uiState.filterProductionType(e.production))
      .toList();
});

// キーワード検索をしているか？
final searchIsKeyword = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((value) => value.isKeywordSearch)));

// お気に入り、周回用/高難易度用での絞り込みフィルターをかけているか
final searchFilterFavorite = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((value) => value.isFavorite)));
final searchFilterUseHighLebel = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((value) => value.isUseHighLevel)));
final searchFilterUseAround = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((value) => value.isUseAround)));

// 絞り込みをかけている武器種
final searchFilterWeaponType = Provider<WeaponType?>((ref) => ref.watch(_uiStateProvider.select((value) => value.weaponType)));

// 絞り込みをかけている属性
final searchFilterAttributeType = Provider<AttributeType?>((ref) => ref.watch(_uiStateProvider.select((value) => value.attributeType)));

// 絞り込みをかけている作品
final searchFilterProductionType = Provider<ProductionType?>((ref) => ref.watch(_uiStateProvider.select((value) => value.productionType)));
