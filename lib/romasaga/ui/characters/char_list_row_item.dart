import 'package:flutter/material.dart';
import 'package:rsapp/romasaga/ui/detail/char_detail_page.dart';
import 'package:rsapp/romasaga/ui/widget/rs_icon.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/weapon.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/common/rs_colors.dart';

class CharListRowItem extends StatelessWidget {
  const CharListRowItem(this.character, {this.index});

  final Character character;
  final int index;

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
          Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (context) => CharDetailPage(character: character)),
          );
        },
      ),
    );
  }

  Container _imageIcon(Character character) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      child: CharacterIcon.normal(character.selectedIconFilePath),
    );
  }

  Column _nameOverview(Character character, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          character.name,
          style: Theme.of(context).textTheme.subtitle1,
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
            _convertWeaponIcon(character.weapon),
          ],
        )
      ],
    );
  }

  Widget _convertWeaponIcon(Weapon weapon) {
    return WeaponIcon.small(weapon.type);
  }

  Widget _labelStatus(Character character, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${RSStrings.hpName} ${character.myStatus.hp}',
          style: TextStyle(
            color: RSColors.characterDetailHpLabel,
          ),
        ),
        Text('${RSStrings.characterTotalStatus} ${character.myStatus.sumWithoutHp()}'),
      ],
    );
  }
}
