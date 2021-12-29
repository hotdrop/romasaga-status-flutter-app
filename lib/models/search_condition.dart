import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/production.dart';
import 'package:rsapp/models/weapon.dart';

class SearchCondition {
  String? keyword;
  WeaponType? weaponType;
  AttributeType? attributeType;
  ProductionType? productionType;
  bool _isFavorite = false;
  bool _isHighLevel = false;
  bool _isAround = false;

  bool filterWord({required String targetName, required String targetProduction}) {
    if (keyword == null) {
      return true;
    }
    return targetName.contains(keyword!) || targetProduction.contains(keyword!);
  }

  bool get isFilterFavorite => _isFavorite;
  bool get isFilterHighLevel => _isHighLevel;
  bool get isFilterAround => _isAround;

  void setFilterCategory({required bool favorite, required bool highLevel, required bool around}) {
    _isFavorite = favorite;
    _isHighLevel = highLevel;
    _isAround = around;
  }

  ///
  /// カテゴリーフィルター
  ///
  bool filterCategory(bool fav, bool isHighLevel) {
    if (_isFavorite) {
      return fav;
    }

    if (_isHighLevel) {
      return fav && isHighLevel;
    }

    if (_isAround) {
      return fav && !isHighLevel;
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
}
