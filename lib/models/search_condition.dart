import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/production.dart';
import 'package:rsapp/models/weapon.dart';

class SearchCondition {
  String? keyword;
  WeaponType? weaponType;
  AttributeType? attributeType;
  ProductionType? productionType;
  bool isFavorite = false;
  bool haveChar = false;

  bool filterWord({required String targetName, required String targetProduction}) {
    if (keyword == null) {
      return true;
    }
    return targetName.contains(keyword!) || targetProduction.contains(keyword!);
  }

  ///
  /// お気に入りフィルター可能
  /// お気に入りでないものはフィルターする価値ないのでしない。
  ///
  bool filterFavorite(bool fav) {
    if (!isFavorite) {
      return true;
    }
    return fav;
  }

  ///
  /// 手持ちキャラのフィルター
  ///
  bool filterHave(bool hav) {
    if (!haveChar) {
      return true;
    }
    return hav;
  }

  ///
  /// 武器種別でのフィルタ
  ///
  bool filterWeaponType(Weapon weapon) {
    if (weaponType == null) {
      return true;
    }
    return weapon.type == weaponType;
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
