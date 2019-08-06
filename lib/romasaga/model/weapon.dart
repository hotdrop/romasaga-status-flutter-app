import '../common/strings.dart';

class WeaponType {
  final String name;

  const WeaponType(this.name);

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

  static List<WeaponType> get types => [
        WeaponType(Strings.Sword),
        WeaponType(Strings.LargeSword),
        WeaponType(Strings.Axe),
        WeaponType(Strings.Hummer),
        WeaponType(Strings.Knuckle),
        WeaponType(Strings.Gun),
        WeaponType(Strings.Rapier),
        WeaponType(Strings.Spear),
        WeaponType(Strings.Bow),
        WeaponType(Strings.MagicFire),
        WeaponType(Strings.MagicWater),
        WeaponType(Strings.MagicWind),
        WeaponType(Strings.MagicYin),
        WeaponType(Strings.MagicShine),
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
