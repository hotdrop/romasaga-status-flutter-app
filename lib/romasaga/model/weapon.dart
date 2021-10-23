import 'package:rsapp/res/rs_strings.dart';

class Weapon {
  Weapon({String name, int type}) {
    if (name != null) {
      _type = _convertType(name);
      _category = _convertCategory(name);
    } else if (type != null) {
      _type = WeaponType.values.firstWhere((v) => v.index == type, orElse: () => null);
      _category = _convertCategoryByType(_type);
    } else {
      throw FormatException('nameまたはtypeが両方nullです。どちらか片方は必ず指定してください');
    }
  }

  WeaponType _type;
  WeaponType get type => _type;

  WeaponCategory _category;
  WeaponCategory get category => _category;

  WeaponType _convertType(String name) {
    switch (name) {
      case RSStrings.sword:
        return WeaponType.sword;
      case RSStrings.largeSword:
        return WeaponType.largeSword;
      case RSStrings.axe:
        return WeaponType.axe;
      case RSStrings.hummer:
        return WeaponType.hummer;
      case RSStrings.knuckle:
        return WeaponType.knuckle;
      case RSStrings.gun:
        return WeaponType.gun;
      case RSStrings.rapier:
        return WeaponType.rapier;
      case RSStrings.spear:
        return WeaponType.spear;
      case RSStrings.bow:
        return WeaponType.bow;
      case RSStrings.rod:
        return WeaponType.rod;
      default:
        throw FormatException('weapon_typeが規定値以外なので武器種別（剣、斧、槍など）を決定できません。 value=$name');
    }
  }

  WeaponCategory _convertCategory(String name) {
    switch (name) {
      case RSStrings.sword:
      case RSStrings.largeSword:
      case RSStrings.axe:
        return WeaponCategory.slash;
      case RSStrings.hummer:
      case RSStrings.knuckle:
      case RSStrings.gun:
        return WeaponCategory.strike;
      case RSStrings.rapier:
      case RSStrings.spear:
      case RSStrings.bow:
        return WeaponCategory.poke;
      case RSStrings.rod:
        return WeaponCategory.rod;
      default:
        throw FormatException('weapon_typeが規定値以外なのでカテゴリー（斬、打、突など）を決定できません。 value=$name');
    }
  }

  WeaponCategory _convertCategoryByType(WeaponType type) {
    switch (type) {
      case WeaponType.sword:
      case WeaponType.largeSword:
      case WeaponType.axe:
        return WeaponCategory.slash;
      case WeaponType.hummer:
      case WeaponType.knuckle:
      case WeaponType.gun:
        return WeaponCategory.strike;
      case WeaponType.rapier:
      case WeaponType.spear:
      case WeaponType.bow:
        return WeaponCategory.poke;
      case WeaponType.rod:
        return WeaponCategory.rod;
      default:
        throw FormatException('weapon_typeが規定値以外なのでカテゴリー（斬、打、突など）を決定できません。 value=$type');
    }
  }
}

enum WeaponType {
  sword,
  largeSword,
  axe,
  hummer,
  knuckle,
  gun,
  rapier,
  spear,
  bow,
  rod,
}

enum WeaponCategory {
  slash, // 斬
  strike, // 打
  poke, // 突
  rod, // 杖
}
