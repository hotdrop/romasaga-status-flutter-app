import '../common/rs_strings.dart';

class WeaponType {
  final String name;

  const WeaponType(this.name);

  WeaponCategory get category {
    switch (name) {
      case RSStrings.sword:
      case RSStrings.largeSword:
      case RSStrings.axe:
        return WeaponCategory.slash;
      case RSStrings.hummer:
      case RSStrings.knuckle:
      case RSStrings.gun:
      case RSStrings.rod:
        return WeaponCategory.strike;
      case RSStrings.rapier:
      case RSStrings.spear:
      case RSStrings.bow:
        return WeaponCategory.poke;
      case RSStrings.magicFire:
        return WeaponCategory.heat;
      case RSStrings.magicWater:
        return WeaponCategory.cold;
      case RSStrings.magicWind:
        return WeaponCategory.thunder;
      case RSStrings.magicYin:
        return WeaponCategory.dark;
      case RSStrings.magicShine:
        return WeaponCategory.light;
      default:
        return null;
    }
  }

  bool isRod() => name == RSStrings.rod;

  bool isMagic() {
    switch (name) {
      case RSStrings.magicFire:
      case RSStrings.magicWater:
      case RSStrings.magicWind:
      case RSStrings.magicYin:
      case RSStrings.magicShine:
        return true;
      default:
        return false;
    }
  }

  int sortOrder() {
    switch (name) {
      case RSStrings.sword:
        return 1;
      case RSStrings.largeSword:
        return 2;
      case RSStrings.axe:
        return 3;
      case RSStrings.hummer:
        return 4;
      case RSStrings.knuckle:
        return 5;
      case RSStrings.gun:
        return 6;
      case RSStrings.rapier:
        return 7;
      case RSStrings.spear:
        return 9;
      case RSStrings.bow:
        return 10;
      case RSStrings.rod:
      case RSStrings.magicFire:
      case RSStrings.magicWater:
      case RSStrings.magicWind:
      case RSStrings.magicYin:
      case RSStrings.magicShine:
        return 11;
      default:
        return 12;
    }
  }

  static List<WeaponType> get types => [
        WeaponType(RSStrings.sword),
        WeaponType(RSStrings.largeSword),
        WeaponType(RSStrings.axe),
        WeaponType(RSStrings.hummer),
        WeaponType(RSStrings.knuckle),
        WeaponType(RSStrings.gun),
        WeaponType(RSStrings.rapier),
        WeaponType(RSStrings.spear),
        WeaponType(RSStrings.bow),
        WeaponType(RSStrings.rod),
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
