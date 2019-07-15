import 'package:flutter/material.dart';
import 'detail/char_detail_page.dart';

import '../model/character.dart';
import '../model/weapon.dart';

import 'widget/romasaga_icon.dart';

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
                  child: _imageIcon(character),
                  flex: 2,
                ),
                Expanded(
                  child: _nameOverview(character, context),
                  flex: 5,
                ),
                Expanded(
                  child: _weaponTypeIcon(character),
                  flex: 2,
                ),
                Expanded(
                  child: _styleIcons(character, context),
                  flex: 3,
                ),
              ],
            )),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharDetailPage(character: character),
            ),
          );
        },
      ),
    );
  }

  Container _imageIcon(Character character) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      child: RomasagaIcon.character(character.iconFileName),
    );
  }

  Column _nameOverview(Character character, BuildContext context) {
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

  Column _weaponTypeIcon(Character character) {
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

  Column _styleIcons(Character character, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: _createStyleIcons(character),
        )
      ],
    );
  }

  List<Widget> _createStyleIcons(Character character) {
    final ranks = character.getStyleRanks(distinct: true);
    return ranks.map((rank) => RomasagaIcon.rank(rank)).toList();
  }
}
