import 'package:flutter/material.dart';

import '../../model/character.dart' show Style, WeaponType;

class RomasagaIcon {
  static Widget convertRankIcon(String rank) {
    if (rank == Style.rankSS) {
      return _imageIcon('res/icons/icon_rank_SS.png');
    } else if (rank == Style.rankS) {
      return _imageIcon('res/icons/icon_rank_S.png');
    } else {
      return _imageIcon('res/icons/icon_rank_A.png');
    }
  }

  static Widget convertWeaponIcon(WeaponType type) {
    switch (type.name) {
      case WeaponType.sword:
        return _imageIcon('res/icons/icon_weap_sword.png');
      case WeaponType.largeSword:
        return _imageIcon('res/icons/icon_weap_large_sword.png');
      case WeaponType.axe:
        return _imageIcon('res/icons/icon_weap_axe.png');
      case WeaponType.hummer:
        return _imageIcon('res/icons/icon_weap_hummer.png');
      case WeaponType.knuckle:
        return _imageIcon('res/icons/icon_weap_knuckle.png');
      case WeaponType.gun:
        return _imageIcon('res/icons/icon_weap_gun.png');
      case WeaponType.rapier:
        return _imageIcon('res/icons/icon_weap_rapier.png');
      case WeaponType.bow:
        return _imageIcon('res/icons/icon_weap_bow.png');
      case WeaponType.spear:
        return _imageIcon('res/icons/icon_weap_spear.png');
      case WeaponType.rod:
        return _imageIcon('res/icons/icon_weap_rod.png');
      default:
        // 本当はここにきたらエラーにすべきだが・・
        return CircleAvatar(
          child: Text("？"),
          backgroundColor: Colors.white,
        );
    }
  }

  static Widget _imageIcon(String res) {
    return Image.asset(
      res,
      width: 30,
      height: 30,
    );
  }
}
