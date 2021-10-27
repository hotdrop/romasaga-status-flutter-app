import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/romasaga/ui/detail/char_detail_page.dart';

class CharListRowItem extends StatelessWidget {
  const CharListRowItem(
    this.character, {
    Key? key,
    required this.refreshListener,
  }) : super(key: key);

  final Character character;
  final Function refreshListener;

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
        onTap: () async {
          bool isUpdate = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (context) => CharDetailPage(character: character)),
          );
          RSLogger.d('詳細画面でステータスが更新されたか？ $isUpdate');
          if (isUpdate) {
            await refreshListener();
          }
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
            WeaponIcon.small(character.weapon.type),
          ],
        )
      ],
    );
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
