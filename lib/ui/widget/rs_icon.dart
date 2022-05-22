import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_images.dart';
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
    return CharacterIcon._(path ?? RSImages.icDefault, 30.0);
  }

  factory CharacterIcon.normal(String? path) {
    return CharacterIcon._(path ?? RSImages.icDefault, 50.0);
  }

  factory CharacterIcon.large(String? path) {
    return CharacterIcon._(path ?? RSImages.icDefault, 80.0);
  }

  final String _res;
  final double _size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _res,
      width: _size,
      height: _size,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, dynamic error) => Image.asset(RSImages.icDefault, width: _size, height: _size),
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
      return const StyleRankIcon._(RSImages.icRankSS);
    } else if (rank.contains(RSStrings.rankS)) {
      return const StyleRankIcon._(RSImages.icRankS);
    } else {
      return const StyleRankIcon._(RSImages.icRankA);
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
        backgroundColor: Theme.of(context).disabledColor,
        child: Image.asset(res, width: _size, height: _size),
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
        return RSImages.icWeaponSword;
      case WeaponType.largeSword:
        return RSImages.icWeaponLargeSword;
      case WeaponType.axe:
        return RSImages.icWeaponAxe;
      case WeaponType.hummer:
        return RSImages.icWeaponHummer;
      case WeaponType.knuckle:
        return RSImages.icWeaponKnuckle;
      case WeaponType.gun:
        return RSImages.icWeaponGun;
      case WeaponType.rapier:
        return RSImages.icWeaponRapier;
      case WeaponType.bow:
        return RSImages.icWeaponBow;
      case WeaponType.spear:
        return RSImages.icWeaponSpear;
      case WeaponType.rod:
        return RSImages.icWeaponRod;
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
      backgroundColor: Theme.of(context).disabledColor,
      child: Image.asset(res, width: _size, height: _size),
    );
  }

  String _getResourcePath() {
    switch (_category) {
      case WeaponCategory.slash:
        return RSImages.icWeaponTypeSlash;
      case WeaponCategory.strike:
        return RSImages.icWeaponTypeStrike;
      case WeaponCategory.poke:
        return RSImages.icWeaponTypePoke;
      case WeaponCategory.rod:
        return RSImages.icWeaponTypeStrike;
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
        backgroundColor: Theme.of(context).disabledColor,
        child: Image.asset(res, width: _size, height: _size),
      );
    }
    return Material(
      shape: const CircleBorder(),
      child: Ink.image(
        image: AssetImage(res),
        fit: BoxFit.cover,
        width: _size,
        height: _size,
        colorFilter: selected ? null : ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.srcATop),
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
        return RSImages.icAttributeFire;
      case AttributeType.cold:
        return RSImages.icAttributeCold;
      case AttributeType.thunder:
        return RSImages.icAttributeThunder;
      case AttributeType.soil:
        return RSImages.icAttributeSoil;
      case AttributeType.wind:
        return RSImages.icAttributeWind;
      case AttributeType.dark:
        return RSImages.icAttributeDark;
      case AttributeType.shine:
        return RSImages.icAttributeShine;
    }
  }
}

///
/// ステータスアイコン
///
class StatusIcon extends StatelessWidget {
  const StatusIcon._(this._res);

  factory StatusIcon.str() {
    return const StatusIcon._(RSImages.icStatusStr);
  }
  factory StatusIcon.vit() {
    return const StatusIcon._(RSImages.icStatusVit);
  }
  factory StatusIcon.dex() {
    return const StatusIcon._(RSImages.icStatusDex);
  }
  factory StatusIcon.agi() {
    return const StatusIcon._(RSImages.icStatusAgi);
  }
  factory StatusIcon.int() {
    return const StatusIcon._(RSImages.icStatusInt);
  }
  factory StatusIcon.spirit() {
    return const StatusIcon._(RSImages.icStatusSpi);
  }
  factory StatusIcon.love() {
    return const StatusIcon._(RSImages.icStatusLove);
  }
  factory StatusIcon.attr() {
    return const StatusIcon._(RSImages.icStatusAttr);
  }

  final String _res;

  @override
  Widget build(BuildContext context) {
    return Image.asset(_res, width: 48.0, height: 48.0);
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
        return RSImages.logoRomasaga1;
      case ProductionType.romasaga2:
        return RSImages.logoRomasaga2;
      case ProductionType.romasaga3:
        return RSImages.logoRomasaga3;
      case ProductionType.sagafro1:
        return RSImages.logoSagaFro1;
      case ProductionType.sagafro2:
        return RSImages.logoSagaFro2;
      case ProductionType.sagasca:
        return RSImages.logoSagaSca;
      case ProductionType.unlimited:
        return RSImages.logoUnlimitedSaga;
      case ProductionType.emperorssaga:
        return RSImages.logoEmperorsSaga;
      case ProductionType.romasagaRS:
        return RSImages.logoRomasagaRS;
      case ProductionType.saga1:
        return RSImages.logoGBSaga1;
      case ProductionType.saga2:
        return RSImages.logoGBSaga2;
      case ProductionType.saga3:
        return RSImages.logoGBSaga3;
    }
  }
}

///
/// 検索画面でのカテゴリーアイコン（お気に入り、高難易度、周回の3つ）
/// これらはいずれかひとつしか選べないようにしているのでまとめてここで定義する。
///
class CategoryIcons extends StatefulWidget {
  const CategoryIcons({
    Key? key,
    required this.isFavSelected,
    required this.isHighLevelSelected,
    required this.isAroundSelected,
    required this.onTap,
  }) : super(key: key);

  final bool isFavSelected;
  final bool isHighLevelSelected;
  final bool isAroundSelected;
  final Function(bool, bool, bool) onTap;

  @override
  State<StatefulWidget> createState() => _CategoryIconsState();
}

class _CategoryIconsState extends State<CategoryIcons> {
  bool _isFavSelected = false;
  bool _isHighLevelSelected = false;
  bool _isAroundSelected = false;

  @override
  void initState() {
    super.initState();
    _isFavSelected = widget.isFavSelected;
    _isHighLevelSelected = widget.isHighLevelSelected;
    _isAroundSelected = widget.isAroundSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: [
        _FavoriteIcon(
          isSelected: _isFavSelected,
          onPressed: () {
            setState(() {
              _isFavSelected = !_isFavSelected;
              _isHighLevelSelected = false;
              _isAroundSelected = false;
            });
            widget.onTap(_isFavSelected, _isHighLevelSelected, _isAroundSelected);
          },
        ),
        _HighLevelIcon(
          isSelected: _isHighLevelSelected,
          onPressed: () {
            setState(() {
              _isFavSelected = false;
              _isHighLevelSelected = !_isHighLevelSelected;
              _isAroundSelected = false;
            });
            widget.onTap(_isFavSelected, _isHighLevelSelected, _isAroundSelected);
          },
        ),
        _AroundIcon(
          isSelected: _isAroundSelected,
          onPressed: () {
            setState(() {
              _isFavSelected = false;
              _isHighLevelSelected = false;
              _isAroundSelected = !_isAroundSelected;
            });
            widget.onTap(_isFavSelected, _isHighLevelSelected, _isAroundSelected);
          },
        ),
      ],
    );
  }
}

class _FavoriteIcon extends StatelessWidget {
  const _FavoriteIcon({Key? key, required this.isSelected, required this.onPressed}) : super(key: key);

  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? RSColors.favoriteSelected : Theme.of(context).disabledColor;
    return _IconButton(
      onPressed: onPressed,
      child: Icon(Icons.star_rounded, color: color, size: 20.0),
    );
  }
}

class _HighLevelIcon extends StatelessWidget {
  const _HighLevelIcon({Key? key, required this.isSelected, required this.onPressed}) : super(key: key);

  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? RSColors.highLevelSelected : Theme.of(context).disabledColor;
    return _IconButton(
      onPressed: onPressed,
      child: Text(RSStrings.highLevelLabel, style: TextStyle(color: color)),
    );
  }
}

class _AroundIcon extends StatelessWidget {
  const _AroundIcon({Key? key, required this.isSelected, required this.onPressed}) : super(key: key);

  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? RSColors.aroundSelected : Theme.of(context).disabledColor;
    return _IconButton(
      onPressed: onPressed,
      child: Text(RSStrings.aroundLabel, style: TextStyle(color: color)),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({Key? key, required this.child, required this.onPressed}) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: const CircleBorder(),
      constraints: const BoxConstraints(
        minWidth: 40.0,
        minHeight: 40.0,
      ),
      fillColor: Theme.of(context).disabledColor,
      onPressed: onPressed,
      child: child,
    );
  }
}
