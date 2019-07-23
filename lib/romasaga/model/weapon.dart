class WeaponType {
  const WeaponType(this.name);

  final String name;

  WeaponCategory get category {
    switch (name) {
      case sword:
      case largeSword:
      case axe:
        return WeaponCategory.slash;
      case hummer:
      case knuckle:
      case gun:
        return WeaponCategory.strike;
      case rapier:
      case spear:
      case bow:
        return WeaponCategory.poke;
      case magicFire:
        return WeaponCategory.heat;
      case magicWater:
        return WeaponCategory.cold;
      case magicWind:
        return WeaponCategory.thunder;
      case magicYin:
        return WeaponCategory.dark;
      case magicShine:
        return WeaponCategory.light;
      default:
        return null;
    }
  }

  // type detail
  static const String sword = '剣';
  static const String largeSword = '大剣';
  static const String axe = '斧';

  static const String hummer = '棍棒';
  static const String knuckle = '体術';
  static const String gun = '銃';

  static const String rapier = '小剣';
  static const String spear = '槍';
  static const String bow = '弓';

  static const String magicFire = '火術';
  static const String magicWater = '水術';
  static const String magicWind = '風術';
  static const String magicYin = '陰術';
  static const String magicShine = '光術';
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
