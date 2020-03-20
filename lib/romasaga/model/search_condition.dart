import 'package:flutter/material.dart';

import 'weapon.dart';

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
  /// お気に入りのみにするか？のみフィルター可能
  /// お気に入りでないものはフィルターする価値ないのでしない。
  ///
  bool filterFavorite(bool fav) {
    if (!isFavorite) {
      return true;
    }
    return fav;
  }

  ///
  /// お気に入りと同様
  ///
  bool filterHave(bool hav) {
    if (!haveChar) {
      return true;
    }
    return hav;
  }

  bool filterWeaponType(WeaponType type) {
    if (weaponType == null) {
      return true;
    }
    // 杖を使用するキャラに設定されている武器種別は系統別の術となっている。
    // 術は水や火など複数あるが武器種別としては「杖」1つのためフィルターは術なら術のもの全部を引っ掛ける
    if (weaponType.isRod()) {
      return type.isMagic();
    } else {
      return type == weaponType;
    }
  }
}
