import 'weapon.dart';

class SearchCondition {
  String keyword;
  WeaponType weaponType;
  bool favorite;
  bool haveChar;

  bool filterWord(String name) {
    if (keyword == null) {
      return true;
    }
    return name.contains(keyword);
  }

  bool filterFavorite(bool fav) {
    if (favorite == null) {
      return true;
    }
    return fav == favorite;
  }

  bool filterHave(bool hav) {
    if (haveChar == null) {
      return true;
    }
    return hav == haveChar;
  }

  bool filterWeaponType(WeaponType type) {
    if (weaponType == null) {
      return true;
    }
    return type == weaponType;
  }
}
