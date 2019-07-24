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
    return _imageIcon(res: path, iconSize: IconSize.large);
  }

  static Widget characterLarge(String fileName) {
    final String path = 'res/charIcons/$fileName';
    return _imageIcon(res: path, iconSize: IconSize.moreLarge);
  }

  ///
  /// スタイルランクアイコン
  ///
  static Widget rank(String rank) {
    return _convertRankIcon(styleRank: rank, iconSize: IconSize.normal);
  }

  static Widget rankSmallSize(String rank) {
    return _convertRankIcon(styleRank: rank, iconSize: IconSize.small);
  }

  static Widget _convertRankIcon({@required String styleRank, IconSize iconSize}) {
    if (styleRank.contains(Style.rankSS)) {
      return _imageIcon(res: 'res/icons/icon_rank_SS.png', iconSize: iconSize);
    } else if (styleRank.contains(Style.rankS)) {
      return _imageIcon(res: 'res/icons/icon_rank_S.png', iconSize: iconSize);
    } else {
      return _imageIcon(res: 'res/icons/icon_rank_A.png', iconSize: iconSize);
    }
  }

  ///
  /// 武器アイコン
  ///
  static Widget weapon(WeaponType type) {
    return _convertWeaponIcon(weaponType: type, iconSize: IconSize.normal);
  }

  static Widget weaponLargeSize(WeaponType type) {
    return _convertWeaponIcon(weaponType: type, iconSize: IconSize.large);
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
        return _imageIcon(res: 'res/icons/icon_type_slash.png');
      case WeaponCategory.strike:
        return _imageIcon(res: 'res/icons/icon_type_strike.png');
      case WeaponCategory.poke:
        return _imageIcon(res: 'res/icons/icon_type_poke.png');
      case WeaponCategory.heat:
        return _imageIcon(res: 'res/icons/icon_type_heat.png');
      case WeaponCategory.cold:
        return _imageIcon(res: 'res/icons/icon_type_cold.png');
      case WeaponCategory.thunder:
        return _imageIcon(res: 'res/icons/icon_type_thunder.png');
      case WeaponCategory.dark:
        return _imageIcon(res: 'res/icons/icon_type_dark.png');
      case WeaponCategory.light:
        return _imageIcon(res: 'res/icons/icon_type_light.png');
      default:
        SagaLogger.d("不正なWeaponCategoryです。category=$category");
        throw FormatException("不正なWeaponCategoryです。category=$category");
    }
  }

  static Widget _imageIcon({@required String res, IconSize iconSize}) {
    double size;
    switch (iconSize) {
      case IconSize.small:
        size = 20.0;
        break;
      case IconSize.large:
        size = 50.0;
        break;
      case IconSize.moreLarge:
        size = 80.0;
        break;
      default:
        size = 30.0;
    }

    return Image.asset(
      res,
      width: size,
      height: size,
    );
  }
}

enum IconSize { small, normal, large, moreLarge }
