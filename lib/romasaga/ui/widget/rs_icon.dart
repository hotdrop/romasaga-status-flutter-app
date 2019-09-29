import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../model/weapon.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';
import '../../common/rs_logger.dart';

class RSIcon {
  static final double smallSize = 30.0;
  static final double normalSize = 50.0;
  static final double largeSize = 80.0;

  ///
  /// キャラアイコン
  ///
  static Widget character(String iconFilePath) {
    return _loadImage(iconFilePath, RSIcon.normalSize);
  }

  static Widget characterLargeSize(String iconFilePath) {
    return _loadImage(iconFilePath, RSIcon.largeSize);
  }

  static Widget _loadImage(String iconFilePath, double size) {
    return CachedNetworkImage(
      imageUrl: iconFilePath,
      width: size,
      height: size,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) {
        return _defaultIcon(size);
      },
    );
  }

  static Widget _defaultIcon(double size) {
    return Image.asset(
      'res/charIcons/default.jpg',
      width: size,
      height: size,
    );
  }

  ///
  /// スタイルランクアイコン
  ///
  static Widget rank(String rank) {
    if (rank.contains(RSStrings.RankSS)) {
      return _imageIcon('res/icons/icon_rank_SS.png', IconSize.small);
    } else if (rank.contains(RSStrings.RankS)) {
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
      color: selected ? RSColors.weaponIconSelectedBackground : RSColors.weaponIconUnSelectedBackground,
      child: Ink.image(
        image: AssetImage(res),
        fit: BoxFit.cover,
        width: normalSize,
        height: normalSize,
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
      constraints: BoxConstraints(
        minWidth: normalSize,
        minHeight: normalSize,
      ),
      fillColor: Theme.of(context).disabledColor,
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
      case RSStrings.Sword:
        return 'res/icons/icon_weap_sword.png';
      case RSStrings.LargeSword:
        return 'res/icons/icon_weap_large_sword.png';
      case RSStrings.Axe:
        return 'res/icons/icon_weap_axe.png';
      case RSStrings.Hummer:
        return 'res/icons/icon_weap_hummer.png';
      case RSStrings.Knuckle:
        return 'res/icons/icon_weap_knuckle.png';
      case RSStrings.Gun:
        return 'res/icons/icon_weap_gun.png';
      case RSStrings.Rapier:
        return 'res/icons/icon_weap_rapier.png';
      case RSStrings.Bow:
        return 'res/icons/icon_weap_bow.png';
      case RSStrings.Spear:
        return 'res/icons/icon_weap_spear.png';
      case RSStrings.Rod:
      case RSStrings.MagicFire:
      case RSStrings.MagicWater:
      case RSStrings.MagicWind:
      case RSStrings.MagicYin:
      case RSStrings.MagicShine:
        return 'res/icons/icon_weap_rod.png';
      default:
        RSLogger.d("不正なWeaponTypeです。weaponType=${weaponType.name}");
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
        RSLogger.d("不正なWeaponCategoryです。category=$category");
        throw FormatException("不正なWeaponCategoryです。category=$category");
    }
  }

  static Widget _imageIcon(String res, IconSize iconSize) {
    double size;
    switch (iconSize) {
      case IconSize.small:
        size = smallSize;
        break;
      case IconSize.normal:
        size = normalSize;
        break;
      case IconSize.large:
        size = largeSize;
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
