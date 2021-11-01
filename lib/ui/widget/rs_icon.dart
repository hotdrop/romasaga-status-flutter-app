import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/production.dart';
import 'package:rsapp/models/weapon.dart';

///
/// キャラクターアイコン
///
class CharacterIcon extends StatelessWidget {
  const CharacterIcon._(this._res, this._size);

  factory CharacterIcon.small(String? path) {
    return CharacterIcon._(path ?? _defaultIconPath, 30.0);
  }

  factory CharacterIcon.normal(String? path) {
    return CharacterIcon._(path ?? _defaultIconPath, 50.0);
  }

  factory CharacterIcon.large(String? path) {
    return CharacterIcon._(path ?? _defaultIconPath, 80.0);
  }

  final String _res;
  final double _size;
  static const _defaultIconPath = 'res/charIcons/default.jpg';

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _res,
      width: _size,
      height: _size,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, dynamic error) => Image.asset(_defaultIconPath, width: _size, height: _size),
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
      return const StyleRankIcon._('res/icons/icon_rank_SS.png');
    } else if (rank.contains(RSStrings.rankS)) {
      return const StyleRankIcon._('res/icons/icon_rank_S.png');
    } else {
      return const StyleRankIcon._('res/icons/icon_rank_A.png');
    }
  }

  final String _res;

  @override
  Widget build(BuildContext context) {
    return Image.asset(_res, width: 30.0, height: 30.0);
  }
}

///
/// 武器アイコン
///
class WeaponIcon extends StatelessWidget {
  const WeaponIcon._(this._type, this._size, this._selected, this._onTap);

  factory WeaponIcon.small(WeaponType type, {bool selected = false, Function? onTap}) {
    return WeaponIcon._(type, 30.0, selected, onTap);
  }

  factory WeaponIcon.normal(WeaponType type, {bool selected = false, Function? onTap}) {
    return WeaponIcon._(type, 50.0, selected, onTap);
  }

  final WeaponType _type;
  final double _size;
  final Function? _onTap;
  final bool _selected;

  @override
  Widget build(BuildContext context) {
    String res = _getResourcePath();
    if (_onTap == null) {
      return CircleAvatar(
        child: Image.asset(res, width: _size, height: _size),
        backgroundColor: Theme.of(context).disabledColor,
      );
    } else {
      return Material(
        shape: const CircleBorder(),
        color: _selected ? RSColors.iconSelectedBackground : Theme.of(context).disabledColor,
        child: Ink.image(
          image: AssetImage(res),
          fit: BoxFit.cover,
          width: _size,
          height: _size,
          child: InkWell(
            onTap: () => _onTap!(),
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
    }
  }
}

///
/// 武器カテゴリーアイコン
///
class WeaponCategoryIcon extends StatelessWidget {
  const WeaponCategoryIcon._(this._category, this._size) //
      : assert(_category != WeaponCategory.rod, 'ロッドは武器カテゴリーアイコンが存在しないため渡してはいけません。');

  factory WeaponCategoryIcon.normal(WeaponCategory category) {
    return WeaponCategoryIcon._(category, 50.0);
  }

  final WeaponCategory _category;
  final double _size;

  @override
  Widget build(BuildContext context) {
    String res = _getResourcePath();
    return CircleAvatar(
      child: Image.asset(res, width: _size, height: _size),
      backgroundColor: Theme.of(context).disabledColor,
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
      case WeaponCategory.rod:
        return 'res/icons/icon_weapon_type_strike.png';
    }
  }
}

class AttributeIcon extends StatelessWidget {
  const AttributeIcon({
    Key? key,
    required this.type,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final AttributeType type;
  final bool selected;
  final Function? onTap;

  final double _size = 50.0;

  @override
  Widget build(BuildContext context) {
    String res = _getResourcePath();
    if (onTap == null) {
      return CircleAvatar(
        child: Image.asset(res, width: _size, height: _size),
        backgroundColor: Theme.of(context).disabledColor,
      );
    }
    return Material(
      shape: const CircleBorder(),
      child: Ink.image(
        image: AssetImage(res),
        fit: BoxFit.cover,
        width: _size,
        height: _size,
        colorFilter: selected ? null : ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
        child: InkWell(
          onTap: () => onTap!(),
          child: null,
        ),
      ),
    );
  }

  String _getResourcePath() {
    switch (type) {
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
    }
  }
}

///
/// ステータスアイコン
///
class StatusIcon extends StatelessWidget {
  const StatusIcon._(this._res);

  factory StatusIcon.str() {
    return const StatusIcon._('res/icons/icon_status_str.png');
  }
  factory StatusIcon.vit() {
    return const StatusIcon._('res/icons/icon_status_vit.png');
  }
  factory StatusIcon.dex() {
    return const StatusIcon._('res/icons/icon_status_dex.png');
  }
  factory StatusIcon.agi() {
    return const StatusIcon._('res/icons/icon_status_agi.png');
  }
  factory StatusIcon.int() {
    return const StatusIcon._('res/icons/icon_status_int.png');
  }
  factory StatusIcon.spirit() {
    return const StatusIcon._('res/icons/icon_status_spi.png');
  }
  factory StatusIcon.love() {
    return const StatusIcon._('res/icons/icon_status_love.png');
  }
  factory StatusIcon.attr() {
    return const StatusIcon._('res/icons/icon_status_attr.png');
  }

  final String _res;

  @override
  Widget build(BuildContext context) {
    return Image.asset(_res, width: 48.0, height: 48.0);
  }
}

///
/// キャラクター所持アイコン
///
class HaveCharacterIcon extends StatelessWidget {
  const HaveCharacterIcon({Key? key, required this.selected, required this.onTap}) : super(key: key);

  final Function onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final icon = selected
        ? Icon(Icons.people, color: Theme.of(context).primaryColor, size: 20.0) //
        : Icon(Icons.people_outline, color: Theme.of(context).disabledColor, size: 20.0);

    return RawMaterialButton(
      shape: const CircleBorder(),
      constraints: const BoxConstraints(
        minWidth: 40.0,
        minHeight: 40.0,
      ),
      fillColor: Theme.of(context).disabledColor,
      child: icon,
      onPressed: () => onTap(),
    );
  }
}

///
/// キャラクターお気に入りアイコン
///
class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({Key? key, required this.selected, required this.onTap}) : super(key: key);

  final Function onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;
    return RawMaterialButton(
      shape: const CircleBorder(),
      constraints: const BoxConstraints(
        minWidth: 40.0,
        minHeight: 40.0,
      ),
      fillColor: Theme.of(context).disabledColor,
      child: Icon(Icons.favorite, color: iconColor, size: 20.0),
      onPressed: () => onTap(),
    );
  }
}

class ProductionLogo extends StatelessWidget {
  const ProductionLogo({
    Key? key,
    required this.type,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final ProductionType type;
  final bool selected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    String res = _getResourcePath();
    return Material(
      child: Ink.image(
        image: AssetImage(res),
        fit: BoxFit.cover,
        width: 90,
        height: 50,
        colorFilter: selected ? null : ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
        child: InkWell(
          onTap: () => onTap(),
          child: null,
        ),
      ),
    );
  }

  String _getResourcePath() {
    switch (type) {
      case ProductionType.romasaga1:
        return 'res/logos/RomancingSaGa1.jpg';
      case ProductionType.romasaga2:
        return 'res/logos/RomancingSaGa2.jpg';
      case ProductionType.romasaga3:
        return 'res/logos/RomancingSaGa3.jpg';
      case ProductionType.sagafro1:
        return 'res/logos/SagaFrontier1.jpg';
      case ProductionType.sagafro2:
        return 'res/logos/SagaFrontier2.jpg';
      case ProductionType.sagasca:
        return 'res/logos/SagaSca.jpg';
      case ProductionType.unlimited:
        return 'res/logos/UnlimitedSage.jpg';
      case ProductionType.emperorssaga:
        return 'res/logos/EmperorsSaga.jpg';
      case ProductionType.romasagaRS:
        return 'res/logos/RomasagaRS.jpg';
      case ProductionType.saga1:
        return 'res/logos/Saga.jpg';
      case ProductionType.saga2:
        return 'res/logos/Saga2.jpg';
    }
  }
}

///
/// ダッシュボードのランキングアイコン
///
class RankingIcon extends StatelessWidget {
  const RankingIcon._(this._res);

  factory RankingIcon.createFirst() => const RankingIcon._('res/icons/icon_ranking_1.png');

  factory RankingIcon.createSecond() => const RankingIcon._('res/icons/icon_ranking_2.png');

  factory RankingIcon.createThird() => const RankingIcon._('res/icons/icon_ranking_3.png');

  factory RankingIcon.createFourth() => const RankingIcon._('res/icons/icon_ranking_4.png');

  factory RankingIcon.createFifth() => const RankingIcon._('res/icons/icon_ranking_5.png');

  final String _res;

  @override
  Widget build(BuildContext context) {
    return Image.asset(_res, width: 30.0, height: 30.0);
  }
}
