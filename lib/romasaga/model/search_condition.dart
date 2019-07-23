import 'weapon.dart';

class SearchCondition {
  
  String keyword;
  WeaponType weaponType;
  bool favorite;
  bool haveChar;

  bool filterWord(String name) {
    return (keyword == null || name.contains(keyword));
  }

  bool filterFavorite(bool fav) {
    return (favorite == null || favorite == fav);
  }

  bool filterHave(bool hav) {
    return (haveChar == null || haveChar == hav);
  }

  bool filterWeaponType(WeaponType type) {
    return (weaponType == null || weaponType == type);
  }
}
