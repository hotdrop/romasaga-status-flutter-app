import 'package:flutter/material.dart';

import '../../model/style.dart';
import '../../model/weapon.dart';

import '../../common/saga_logger.dart';

class RomasagaIcon {
  ///
  /// キャラクターアイコン
  ///
  static Widget character(String fileName) {
    final String path = 'res/charIcons/$fileName';
    return _imageIcon(res: path, iconSize: IconSize.normal);
  }

  static Widget characterLarge(String fileName) {
    final String path = 'res/charIcons/$fileName';
    return _imageIcon(res: path, iconSize: IconSize.large);
  }

  ///
  /// スタイルランクアイコン
  ///
  static Widget rank(String rank) {
    if (rank.contains(Style.rankSS)) {
      return _imageIcon(res: 'res/icons/icon_rank_SS.png', iconSize: IconSize.small);
    } else if (rank.contains(Style.rankS)) {
      return _imageIcon(res: 'res/icons/icon_rank_S.png', iconSize: IconSize.small);
    } else {
      return _imageIcon(res: 'res/icons/icon_rank_A.png', iconSize: IconSize.small);
    }
  }

  ///
  /// 武器アイコン
  ///
  static Widget weaponSmall(WeaponType type) {
    return _convertWeaponIcon(weaponType: type, iconSize: IconSize.small);
  }

  static Widget weapon(WeaponType type) {
    return _convertWeaponIcon(weaponType: type, iconSize: IconSize.normal);
  }

  static Widget _convertWeaponIcon({@required WeaponType weaponType, IconSize iconSize}) {
    switch (weaponType.name) {
      case WeaponType.sword:
        return _imageIcon(res: 'res/icons/icon_weap_sword.png', iconSize: iconSize);
      case WeaponType.largeSword:
        return _imageIcon(res: 'res/icons/icon_weap_large_sword.png', iconSize: iconSize);
      case WeaponType.axe:
        return _imageIcon(res: 'res/icons/icon_weap_axe.png', iconSize: iconSize);
      case WeaponType.hummer:
        return _imageIcon(res: 'res/icons/icon_weap_hummer.png', iconSize: iconSize);
      case WeaponType.knuckle:
        return _imageIcon(res: 'res/icons/icon_weap_knuckle.png', iconSize: iconSize);
      case WeaponType.gun:
        return _imageIcon(res: 'res/icons/icon_weap_gun.png', iconSize: iconSize);
      case WeaponType.rapier:
        return _imageIcon(res: 'res/icons/icon_weap_rapier.png', iconSize: iconSize);
      case WeaponType.bow:
        return _imageIcon(res: 'res/icons/icon_weap_bow.png', iconSize: iconSize);
      case WeaponType.spear:
        return _imageIcon(res: 'res/icons/icon_weap_spear.png', iconSize: iconSize);
      case WeaponType.magicFire:
      case WeaponType.magicWater:
      case WeaponType.magicWind:
      case WeaponType.magicYin:
      case WeaponType.magicShine:
        return _imageIcon(res: 'res/icons/icon_weap_rod.png', iconSize: iconSize);
      default:
        SagaLogger.d("不正なWeaponTypeです。weaponType=${weaponType.name}");
        throw FormatException("不正なWeaponTypeです。weaponType=${weaponType.name}");
    }
  }

  ///
  /// 属性アイコン
  ///
  static Widget weaponCategory({@required WeaponCategory category}) {
    switch (category) {
      case WeaponCategory.slash:
        return _imageIcon(res: 'res/icons/icon_type_slash.png', iconSize: IconSize.normal);
      case WeaponCategory.strike:
        return _imageIcon(res: 'res/icons/icon_type_strike.png', iconSize: IconSize.normal);
      case WeaponCategory.poke:
        return _imageIcon(res: 'res/icons/icon_type_poke.png', iconSize: IconSize.normal);
      case WeaponCategory.heat:
        return _imageIcon(res: 'res/icons/icon_type_heat.png', iconSize: IconSize.normal);
      case WeaponCategory.cold:
        return _imageIcon(res: 'res/icons/icon_type_cold.png', iconSize: IconSize.normal);
      case WeaponCategory.thunder:
        return _imageIcon(res: 'res/icons/icon_type_thunder.png', iconSize: IconSize.normal);
      case WeaponCategory.dark:
        return _imageIcon(res: 'res/icons/icon_type_dark.png', iconSize: IconSize.normal);
      case WeaponCategory.light:
        return _imageIcon(res: 'res/icons/icon_type_light.png', iconSize: IconSize.normal);
      default:
        SagaLogger.d("不正なWeaponCategoryです。category=$category");
        throw FormatException("不正なWeaponCategoryです。category=$category");
    }
  }

  static Widget _imageIcon({@required String res, IconSize iconSize}) {
    double size;
    switch (iconSize) {
      case IconSize.small:
        size = 30.0;
        break;
      case IconSize.normal:
        size = 50.0;
        break;
      case IconSize.large:
        size = 80.0;
        break;
      default:
        size = 0;
    }

    return Image.asset(
      res,
      width: size,
      height: size,
    );
  }
}

enum IconSize { small, normal, large }
