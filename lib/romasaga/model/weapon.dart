import '../common/strings.dart';

class WeaponType {
  const WeaponType(this.name);

  final String name;

  WeaponCategory get category {
    switch (name) {
      case Strings.Sword:
      case Strings.LargeSword:
      case Strings.Axe:
        return WeaponCategory.slash;
      case Strings.Hummer:
      case Strings.Knuckle:
      case Strings.Gun:
        return WeaponCategory.strike;
      case Strings.Rapier:
      case Strings.Spear:
      case Strings.Bow:
        return WeaponCategory.poke;
      case Strings.MagicFire:
        return WeaponCategory.heat;
      case Strings.MagicWater:
        return WeaponCategory.cold;
      case Strings.MagicWind:
        return WeaponCategory.thunder;
      case Strings.MagicYin:
        return WeaponCategory.dark;
      case Strings.MagicShine:
        return WeaponCategory.light;
      default:
        return null;
    }
  }
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
