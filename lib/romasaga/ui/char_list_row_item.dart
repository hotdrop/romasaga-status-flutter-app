import 'package:flutter/material.dart';

import '../model/character.dart';
import 'detail/char_detail_page.dart';

class CharListRowItem extends StatelessWidget {
  final Character character;
  final int index;

  const CharListRowItem({this.character, this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _widgetThumbnail(character),
                  flex: 1,
                ),
                Expanded(
                  child: _widgetCharNameAndStyles(character, context),
                  flex: 3,
                ),
                Expanded(
                  child: _widgetWeaponType(character),
                  flex: 1,
                ),
                Expanded(
                  child: _widgetFavoriteIcon(character),
                  flex: 1,
                )
              ],
            )),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharDetailPage(
                    character: character,
                  ),
            ),
          );
        },
      ),
    );
  }

  Container _widgetThumbnail(Character character) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      child: CircleAvatar(
        // TODO 画像どうやって持ってくるか・・
        child: Text(character.name[0]),
      ),
    );
  }

  Column _widgetCharNameAndStyles(Character character, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          character.name,
          style: Theme.of(context).textTheme.subhead,
        ),
        Row(
          children: _widgetStyleIcons(character),
        )
      ],
    );
  }

  Column _widgetWeaponType(Character character) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _convertWeaponIcon(character.weaponType),
          ],
        )
      ],
    );
  }

  Column _widgetFavoriteIcon(Character character) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Icon(Icons.favorite_border)],
        )
      ],
    );
  }

  List<Widget> _widgetStyleIcons(Character character) {
    return character.styleRanks.map((rank) => _convertRankToIcon(rank)).toList();
  }

  // TODO ここら辺は画像リソース扱うクラス作ってそこでやる
  Widget _convertRankToIcon(String rank) {
    if (rank == Style.rankSS) {
      return _imageIcon('res/icons/icon_rank_SS.png');
    } else if (rank == Style.rankS) {
      return _imageIcon('res/icons/icon_rank_S.png');
    } else {
      return _imageIcon('res/icons/icon_rank_A.png');
    }
  }

  Widget _convertWeaponIcon(WeaponType type) {
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

  Widget _imageIcon(String res) {
    return Image.asset(
      res,
      width: 30,
      height: 30,
    );
  }
}
