import '../common/rs_strings.dart';

class WeaponType {
  final String name;

  const WeaponType(this.name);

  WeaponCategory get category {
    switch (name) {
      case RSStrings.Sword:
      case RSStrings.LargeSword:
      case RSStrings.Axe:
        return WeaponCategory.slash;
      case RSStrings.Hummer:
      case RSStrings.Knuckle:
      case RSStrings.Gun:
      case RSStrings.Rod:
        return WeaponCategory.strike;
      case RSStrings.Rapier:
      case RSStrings.Spear:
      case RSStrings.Bow:
        return WeaponCategory.poke;
      case RSStrings.MagicFire:
        return WeaponCategory.heat;
      case RSStrings.MagicWater:
        return WeaponCategory.cold;
      case RSStrings.MagicWind:
        return WeaponCategory.thunder;
      case RSStrings.MagicYin:
        return WeaponCategory.dark;
      case RSStrings.MagicShine:
        return WeaponCategory.light;
      default:
        return null;
    }
  }

  bool isRod() => name == RSStrings.Rod;

  bool isMagic() {
    switch (name) {
      case RSStrings.MagicFire:
      case RSStrings.MagicWater:
      case RSStrings.MagicWind:
      case RSStrings.MagicYin:
      case RSStrings.MagicShine:
        return true;
      default:
        return false;
    }
  }

  int sortOrder() {
    switch (name) {
      case RSStrings.Sword:
        return 1;
      case RSStrings.LargeSword:
        return 2;
      case RSStrings.Axe:
        return 3;
      case RSStrings.Hummer:
        return 4;
      case RSStrings.Knuckle:
        return 5;
      case RSStrings.Gun:
        return 6;
      case RSStrings.Rapier:
        return 7;
      case RSStrings.Spear:
        return 9;
      case RSStrings.Bow:
        return 10;
      case RSStrings.Rod:
      case RSStrings.MagicFire:
      case RSStrings.MagicWater:
      case RSStrings.MagicWind:
      case RSStrings.MagicYin:
      case RSStrings.MagicShine:
        return 11;
      default:
        return 12;
    }
  }

  static List<WeaponType> get types => [
        WeaponType(RSStrings.Sword),
        WeaponType(RSStrings.LargeSword),
        WeaponType(RSStrings.Axe),
        WeaponType(RSStrings.Hummer),
        WeaponType(RSStrings.Knuckle),
        WeaponType(RSStrings.Gun),
        WeaponType(RSStrings.Rapier),
        WeaponType(RSStrings.Spear),
        WeaponType(RSStrings.Bow),
        WeaponType(RSStrings.Rod),
      ];

  bool operator ==(o) => o is WeaponType && o.name == name;

  int get hashCode => name.hashCode;
}

enum WeaponCategory {
  slash, // 斬
  strike, // 打
  poke, // 突
  heat, // 熱
  cold, // 冷
  thunder, // 雷
  dark, // 陰
  light, // 陽
}
