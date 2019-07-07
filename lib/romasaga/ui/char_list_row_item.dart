import 'package:flutter/material.dart';

import 'common/romasagaIcon.dart';
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
                  child: _widgetName(character, context),
                  flex: 3,
                ),
                Expanded(
                  child: _widgetWeaponType(character),
                  flex: 1,
                ),
                Expanded(
                  child: _widgetStyles(character, context),
                  flex: 2,
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
      child: RomasagaIcon.character(character.iconFileName),
    );
  }

  Column _widgetName(Character character, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          character.name,
          style: Theme.of(context).textTheme.subhead,
        ),
        Text(
          character.title,
          style: Theme.of(context).textTheme.caption,
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

  Widget _convertWeaponIcon(WeaponType type) {
    return RomasagaIcon.weapon(type);
  }

  Column _widgetStyles(Character character, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: _widgetStyleIcons(character),
        )
      ],
    );
  }

  List<Widget> _widgetStyleIcons(Character character) {
    final ranks = character.getStyleRanks(distinct: true);
    return ranks.map((rank) => RomasagaIcon.rank(rank)).toList();
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
}
