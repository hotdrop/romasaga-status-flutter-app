import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rsapp/romasaga/model/attribute.dart';
import 'package:rsapp/romasaga/model/weapon.dart';
import 'package:rsapp/romasaga/common/rs_colors.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';

///
/// キャラクターアイコン
///
class CharacterIcon extends StatelessWidget {
  const CharacterIcon._(this._res, this._size);

  factory CharacterIcon.small(String path) {
    return CharacterIcon._(path, 30.0);
  }

  factory CharacterIcon.normal(String path) {
    return CharacterIcon._(path, 50.0);
  }

  factory CharacterIcon.large(String path) {
    return CharacterIcon._(path, 80.0);
  }

  final String _res;
  final double _size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _res,
      width: _size,
      height: _size,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, dynamic error) => Image.asset('res/charIcons/default.jpg', width: _size, height: _size),
    );
  }
}

///
/// スタイルランクアイコン
///
class StyleRankIcon extends StatelessWidget {
  const StyleRankIcon._(this._res);

  factory StyleRankIcon.create(String rank) {
    if (rank.contains(RSStrings.rankSS)) {
      return StyleRankIcon._('res/icons/icon_rank_SS.png');
    } else if (rank.contains(RSStrings.rankS)) {
      return StyleRankIcon._('res/icons/icon_rank_S.png');
    } else {
      return StyleRankIcon._('res/icons/icon_rank_A.png');
    }
  }

  final String _res;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _res,
      width: 30.0,
      height: 30.0,
    );
  }
}

///
/// 武器アイコン
///
class WeaponIcon extends StatelessWidget {
  const WeaponIcon._(this._type, this._size, this._selected, this._onTap);

  factory WeaponIcon.small(WeaponType type, {bool selected, void Function() onTap}) {
    return WeaponIcon._(type, 30.0, selected, onTap);
  }

  factory WeaponIcon.normal(WeaponType type, {bool selected, void Function() onTap}) {
    return WeaponIcon._(type, 50.0, selected, onTap);
  }

  final WeaponType _type;
  final double _size;
  final void Function() _onTap;
  final bool _selected;

  @override
  Widget build(BuildContext context) {
    String res = _getResourcePath();
    if (_onTap == null) {
      return Image.asset(
        res,
        width: _size,
        height: _size,
      );
    } else {
      return Material(
        shape: CircleBorder(),
        color: _selected ? RSColors.weaponIconSelectedBackground : Theme.of(context).disabledColor,
        child: Ink.image(
          image: AssetImage(res),
          fit: BoxFit.cover,
          width: _size,
          height: _size,
          child: InkWell(
            onTap: () => _onTap(),
            child: null,
          ),
        ),
      );
    }
  }

  String _getResourcePath() {
    switch (_type) {
      case WeaponType.sword:
        return 'res/icons/icon_weapon_sword.png';
      case WeaponType.largeSword:
        return 'res/icons/icon_weapon_large_sword.png';
      case WeaponType.axe:
        return 'res/icons/icon_weapon_axe.png';
      case WeaponType.hummer:
        return 'res/icons/icon_weapon_hummer.png';
      case WeaponType.knuckle:
        return 'res/icons/icon_weapon_knuckle.png';
      case WeaponType.gun:
        return 'res/icons/icon_weapon_gun.png';
      case WeaponType.rapier:
        return 'res/icons/icon_weapon_rapier.png';
      case WeaponType.bow:
        return 'res/icons/icon_weapon_bow.png';
      case WeaponType.spear:
        return 'res/icons/icon_weapon_spear.png';
      case WeaponType.rod:
        return 'res/icons/icon_weapon_rod.png';
      default:
        throw FormatException("不正なWeaponTypeです。weaponType=$_type");
    }
  }
}

///
/// 武器カテゴリーアイコン
///
class WeaponCategoryIcon extends StatelessWidget {
  const WeaponCategoryIcon(this._category) : assert(_category != WeaponCategory.rod, 'ロッドは武器カテゴリーアイコンが存在しないため渡してはいけません。');

  final WeaponCategory _category;

  @override
  Widget build(BuildContext context) {
    String res = _getResourcePath();
    return Image.asset(
      res,
      width: 50.0,
      height: 50.0,
    );
  }

  String _getResourcePath() {
    switch (_category) {
      case WeaponCategory.slash:
        return 'res/icons/icon_weapon_type_slash.png';
      case WeaponCategory.strike:
        return 'res/icons/icon_weapon_type_strike.png';
      case WeaponCategory.poke:
        return 'res/icons/icon_weapon_type_poke.png';
      default:
        throw FormatException("不正なCategoryです。attribute=$_category");
    }
  }
}

class AttributeIcon extends StatelessWidget {
  const AttributeIcon(this._attribute);

  final AttributeType _attribute;

  @override
  Widget build(BuildContext context) {
    String res = _getResourcePath();
    return Image.asset(
      res,
      width: 50.0,
      height: 50.0,
    );
  }

  String _getResourcePath() {
    switch (_attribute) {
      case AttributeType.fire:
        return 'res/icons/icon_attribute_fire.png';
      case AttributeType.cold:
        return 'res/icons/icon_attribute_cold.png';
      case AttributeType.thunder:
        return 'res/icons/icon_attribute_thunder.png';
      case AttributeType.soil:
        return 'res/icons/icon_attribute_soil.png';
      case AttributeType.wind:
        return 'res/icons/icon_attribute_wind.png';
      case AttributeType.dark:
        return 'res/icons/icon_attribute_dark.png';
      case AttributeType.shine:
        return 'res/icons/icon_attribute_shine.png';
      default:
        throw FormatException("不正なAttributeです。attribute=$_attribute");
    }
  }
}

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

///
/// キャラクター所持アイコン
///
class HaveCharacterIcon extends StatelessWidget {
  const HaveCharacterIcon({@required this.selected, @required this.onTap});

  final void Function() onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? Theme.of(context).accentColor : Theme.of(context).disabledColor;
    return RawMaterialButton(
      shape: CircleBorder(),
      constraints: BoxConstraints(
        minWidth: 50.0,
        minHeight: 50.0,
      ),
      fillColor: Theme.of(context).disabledColor,
      child: Icon(
        Icons.check,
        color: iconColor,
        size: 30.0,
      ),
      onPressed: onTap,
    );
  }
}

///
/// キャラクターお気に入りアイコン
///
class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({@required this.selected, @required this.onTap});

  final void Function() onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? Theme.of(context).accentColor : Theme.of(context).disabledColor;
    return RawMaterialButton(
      shape: CircleBorder(),
      constraints: BoxConstraints(
        minWidth: 50.0,
        minHeight: 50.0,
      ),
      fillColor: Theme.of(context).disabledColor,
      child: Icon(
        Icons.favorite,
        color: iconColor,
        size: 30.0,
      ),
      onPressed: onTap,
    );
  }
}
