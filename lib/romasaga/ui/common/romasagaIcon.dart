import 'package:flutter/material.dart';

import '../../model/character.dart' show Style, WeaponType;

class RomasagaIcon {
  static Widget convertRankIcon(String rank) {
    return _convertRankIcon(styleRank: rank, iconSize: IconSize.normal);
  }

  static Widget convertRankIconWithSmallSize(String rank) {
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

  static Widget convertWeaponIcon(WeaponType type) {
    return _convertWeaponIcon(weaponType: type, iconSize: IconSize.normal);
  }

  static Widget convertWeaponIconWithLargeSize(WeaponType type) {
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
      case WeaponType.rod:
        return _imageIcon(res: 'res/icons/icon_weap_rod.png', iconSize: iconSize);
      default:
        // 本当はここにきたらエラーにすべきだが・・
        return CircleAvatar(
          child: Text("？"),
          backgroundColor: Colors.white,
        );
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

enum IconSize { small, normal, large }
