import 'package:flutter/material.dart';

import '../../model/weapon.dart';

import '../../common/strings.dart';
import '../../common/saga_logger.dart';

class RomasagaIcon {
  ///
  /// キャラクターアイコン
  ///
  static Widget character(String fileName) {
    final path = 'res/charIcons/$fileName';
    return _imageIcon(path, IconSize.normal);
  }

  static Widget characterLarge(String fileName) {
    final path = 'res/charIcons/$fileName';
    return _imageIcon(path, IconSize.large);
  }

  ///
  /// スタイルランクアイコン
  ///
  static Widget rank(String rank) {
    if (rank.contains(Strings.RankSS)) {
      return _imageIcon('res/icons/icon_rank_SS.png', IconSize.small);
    } else if (rank.contains(Strings.RankS)) {
      return _imageIcon('res/icons/icon_rank_S.png', IconSize.small);
    } else {
      return _imageIcon('res/icons/icon_rank_A.png', IconSize.small);
    }
  }

  ///
  /// 武器アイコン
  ///
  static Widget weaponSmall(WeaponType type) {
    return _convertWeaponIcon(type, IconSize.small);
  }

  static Widget weapon(WeaponType type) {
    return _convertWeaponIcon(type, IconSize.normal);
  }

  ///
  /// Ripple付きの武器アイコン
  /// 選択しているかしていないかの指定も可能
  ///
  static Widget weaponWithRipple({@required WeaponType type, @required Function onTap, bool selected = false}) {
    String res = _getWeaponIconRes(type);
    return Material(
      shape: CircleBorder(),
      color: selected ? Colors.yellowAccent : Colors.grey,
      child: Ink.image(
        image: AssetImage(res),
        fit: BoxFit.cover,
        width: 50.0,
        height: 50.0,
        child: InkWell(
          onTap: onTap,
          child: null,
        ),
      ),
    );
  }

  ///
  /// チェックアイコン
  ///
  static Widget haveCharacterWithRipple({@required BuildContext context, @required Function onTap, @required bool selected}) {
    return _createIconWithRipple(context, onTap, selected, Icons.check);
  }

  ///
  /// お気に入りアイコン
  ///
  static Widget favoriteWithRipple({@required BuildContext context, @required Function onTap, @required bool selected}) {
    return _createIconWithRipple(context, onTap, selected, Icons.favorite);
  }

  static Widget _createIconWithRipple(BuildContext context, Function onTap, bool selected, IconData icon) {
    final iconColor = selected ? Theme.of(context).accentColor : Theme.of(context).disabledColor;
    return RawMaterialButton(
      shape: CircleBorder(),
      constraints: BoxConstraints(minWidth: 50.0, minHeight: 50.0),
      fillColor: Color.fromARGB(255, 80, 80, 80), // TODO こういうのColorResにまとめたい
      child: Icon(
        icon,
        color: iconColor,
        size: 30.0,
      ),
      onPressed: onTap,
    );
  }

  static Widget _convertWeaponIcon(WeaponType weaponType, IconSize iconSize) {
    String res = _getWeaponIconRes(weaponType);
    return _imageIcon(res, iconSize);
  }

  static String _getWeaponIconRes(WeaponType weaponType) {
    switch (weaponType.name) {
      case Strings.Sword:
        return 'res/icons/icon_weap_sword.png';
      case Strings.LargeSword:
        return 'res/icons/icon_weap_large_sword.png';
      case Strings.Axe:
        return 'res/icons/icon_weap_axe.png';
      case Strings.Hummer:
        return 'res/icons/icon_weap_hummer.png';
      case Strings.Knuckle:
        return 'res/icons/icon_weap_knuckle.png';
      case Strings.Gun:
        return 'res/icons/icon_weap_gun.png';
      case Strings.Rapier:
        return 'res/icons/icon_weap_rapier.png';
      case Strings.Bow:
        return 'res/icons/icon_weap_bow.png';
      case Strings.Spear:
        return 'res/icons/icon_weap_spear.png';
      case Strings.MagicFire:
      case Strings.MagicWater:
      case Strings.MagicWind:
      case Strings.MagicYin:
      case Strings.MagicShine:
        return 'res/icons/icon_weap_rod.png';
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
        return _imageIcon('res/icons/icon_type_slash.png', IconSize.normal);
      case WeaponCategory.strike:
        return _imageIcon('res/icons/icon_type_strike.png', IconSize.normal);
      case WeaponCategory.poke:
        return _imageIcon('res/icons/icon_type_poke.png', IconSize.normal);
      case WeaponCategory.heat:
        return _imageIcon('res/icons/icon_type_heat.png', IconSize.normal);
      case WeaponCategory.cold:
        return _imageIcon('res/icons/icon_type_cold.png', IconSize.normal);
      case WeaponCategory.thunder:
        return _imageIcon('res/icons/icon_type_thunder.png', IconSize.normal);
      case WeaponCategory.dark:
        return _imageIcon('res/icons/icon_type_dark.png', IconSize.normal);
      case WeaponCategory.light:
        return _imageIcon('res/icons/icon_type_light.png', IconSize.normal);
      default:
        SagaLogger.d("不正なWeaponCategoryです。category=$category");
        throw FormatException("不正なWeaponCategoryです。category=$category");
    }
  }

  static Widget _imageIcon(String res, IconSize iconSize) {
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
