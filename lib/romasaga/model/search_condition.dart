import 'package:flutter/material.dart';
import 'package:rsapp/romasaga/model/weapon.dart';

class SearchCondition {
  String keyword;
  WeaponType weaponType;
  bool isFavorite = false;
  bool haveChar = false;

  bool filterWord({@required String targetName, @required String targetProduction}) {
    if (keyword == null) {
      return true;
    }
    return targetName.contains(keyword) || targetProduction.contains(keyword);
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
}
