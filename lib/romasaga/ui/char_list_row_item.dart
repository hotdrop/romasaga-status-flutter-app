import 'package:flutter/material.dart';
import 'detail/char_detail_page.dart';

import '../model/character.dart';
import '../model/weapon.dart';

import 'widget/rs_icon.dart';
import 'widget/character_icon_loader.dart';

import '../common/rs_strings.dart';

class CharListRowItem extends StatelessWidget {
  final Character character;
  final int index;
  final CharacterIconLoader charIconLoader;

  const CharListRowItem(this.character, this.charIconLoader, {this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(child: _imageIcon(character), flex: 2),
                Expanded(child: _nameOverview(character, context), flex: 5),
                Expanded(child: _weaponTypeIcon(character), flex: 2),
                Expanded(child: _labelStatus(character, context), flex: 3),
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
      child: charIconLoader.load(character.selectedIconFileName),
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
          character.production,
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }

  Column _weaponTypeIcon(Character character) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _convertWeaponIcon(character.weaponType),
          ],
        )
      ],
    );
  }

  Widget _convertWeaponIcon(WeaponType type) {
    return RSIcon.weaponSmall(type);
  }

  Widget _labelStatus(Character character, BuildContext context) {
    return Text('${RSStrings.CharacterTotalStatus} ${character.getTotalStatus()}');
  }
}
