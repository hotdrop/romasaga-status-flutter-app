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
      placeholder: (context, url) => const CircularProgressIndicator(), // ここはCircularProgressIndicatorを使う
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
    super.key,
    required this.type,
    this.selected = false,
    this.onTap,
  });

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
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

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

class TabIcon extends StatelessWidget {
  const TabIcon._(this.iconData, {required this.iconColor, this.iconSize, this.count});

  factory TabIcon.statusUp({Color color = RSColors.statusUpEventSelected, int? count}) {
    return TabIcon._(Icons.trending_up, iconColor: color, count: count);
  }

  factory TabIcon.favorite({required bool isSelected, Color color = RSColors.favoriteSelected, double? size, int? count}) {
    if (isSelected) {
      return TabIcon._(Icons.star_rounded, iconColor: color, iconSize: size, count: count);
    } else {
      return TabIcon._(Icons.star_border_rounded, iconColor: color, iconSize: size, count: count);
    }
  }

  final IconData iconData;
  final Color iconColor;
  final double? iconSize;
  final int? count; // アイコンの横にカウントを入れたい場合はこれを使う

  @override
  Widget build(BuildContext context) {
    if (count != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: iconColor, size: iconSize),
          Text('($count)'),
        ],
      );
    } else {
      return Icon(iconData, color: iconColor, size: iconSize);
    }
  }
}

///
/// 検索画面でのカテゴリーアイコン（お気に入りだけ）
///
class CategoryIcons extends StatefulWidget {
  const CategoryIcons({
    super.key,
    required this.isFavSelected,
    required this.onTap,
  });

  final bool isFavSelected;
  final Function(bool) onTap;

  @override
  State<StatefulWidget> createState() => _CategoryIconsState();
}

class _CategoryIconsState extends State<CategoryIcons> {
  bool _isFavSelected = false;

  @override
  void initState() {
    super.initState();
    _isFavSelected = widget.isFavSelected;
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
            });
            widget.onTap(_isFavSelected);
          },
        ),
      ],
    );
  }
}

class _FavoriteIcon extends StatelessWidget {
  const _FavoriteIcon({required this.isSelected, required this.onPressed});

  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _IconButton(
      onPressed: onPressed,
      child: TabIcon.favorite(
        isSelected: isSelected,
        color: isSelected ? RSColors.favoriteSelected : Theme.of(context).disabledColor,
        size: 20.0,
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.child, required this.onPressed});

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
