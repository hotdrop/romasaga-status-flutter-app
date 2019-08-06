import 'weapon.dart';

class SearchCondition {
  String keyword;
  WeaponType weaponType;
  bool isFavorite = false;
  bool haveChar = false;

  bool filterWord(String name) {
    if (keyword == null) {
      return true;
    }
    return name.contains(keyword);
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
    return type == weaponType;
  }
}
