import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../model/weapon.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';
import '../../common/rs_logger.dart';

/// このFlutter初学の頃に書いたアホみたいなstatic実装なんとかしたほうがいい・・
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

  static Widget characterSmallSize(String iconFilePath) {
    return _loadImage(iconFilePath, RSIcon.smallSize);
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
    if (rank.contains(RSStrings.rankSS)) {
      return _imageIcon('res/icons/icon_rank_SS.png', IconSize.small);
    } else if (rank.contains(RSStrings.rankS)) {
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
  static Widget weaponWithRipple(
    BuildContext context, {
    @required WeaponType type,
    @required void Function() onTap,
    bool selected = false,
  }) {
    String res = _getWeaponIconRes(type);
    return Material(
      shape: CircleBorder(),
      color: selected ? RSColors.weaponIconSelectedBackground : Theme.of(context).disabledColor,
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
  static Widget haveCharacterWithRipple({@required BuildContext context, @required void Function() onTap, @required bool selected}) {
    return _createIconWithRipple(context, onTap, selected, Icons.check);
  }

  ///
  /// お気に入りアイコン
  ///
  static Widget favoriteWithRipple({@required BuildContext context, @required void Function() onTap, @required bool selected}) {
    return _createIconWithRipple(context, onTap, selected, Icons.favorite);
  }

  static Widget _createIconWithRipple(BuildContext context, void Function() onTap, bool selected, IconData icon) {
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
      case RSStrings.sword:
        return 'res/icons/icon_weap_sword.png';
      case RSStrings.largeSword:
        return 'res/icons/icon_weap_large_sword.png';
      case RSStrings.axe:
        return 'res/icons/icon_weap_axe.png';
      case RSStrings.hummer:
        return 'res/icons/icon_weap_hummer.png';
      case RSStrings.knuckle:
        return 'res/icons/icon_weap_knuckle.png';
      case RSStrings.gun:
        return 'res/icons/icon_weap_gun.png';
      case RSStrings.rapier:
        return 'res/icons/icon_weap_rapier.png';
      case RSStrings.bow:
        return 'res/icons/icon_weap_bow.png';
      case RSStrings.spear:
        return 'res/icons/icon_weap_spear.png';
      case RSStrings.rod:
      case RSStrings.magicFire:
      case RSStrings.magicWater:
      case RSStrings.magicWind:
      case RSStrings.magicYin:
      case RSStrings.magicShine:
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

///
/// ステータスアイコン
///
class StatusIcon extends StatelessWidget {
  const StatusIcon._(this._res);

  factory StatusIcon.str() {
    return StatusIcon._('res/icons/icon_status_str.png');
  }

  factory StatusIcon.vit() {
    return StatusIcon._('res/icons/icon_status_vit.png');
  }

  factory StatusIcon.dex() {
    return StatusIcon._('res/icons/icon_status_dex.png');
  }
  factory StatusIcon.agi() {
    return StatusIcon._('res/icons/icon_status_agi.png');
  }
  factory StatusIcon.int() {
    return StatusIcon._('res/icons/icon_status_int.png');
  }
  factory StatusIcon.spi() {
    return StatusIcon._('res/icons/icon_status_spi.png');
  }
  factory StatusIcon.love() {
    return StatusIcon._('res/icons/icon_status_love.png');
  }
  factory StatusIcon.attr() {
    return StatusIcon._('res/icons/icon_status_attr.png');
  }

  final String _res;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _res,
      width: 48.0,
      height: 48.0,
    );
  }
}
