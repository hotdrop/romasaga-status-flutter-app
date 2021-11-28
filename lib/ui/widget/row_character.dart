import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/ui/character/detail/character_detail_page.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class RowCharacterItem extends StatelessWidget {
  const RowCharacterItem(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _viewLeadingArea(context),
                _viewTrailingArea(context),
              ],
            )),
        onTap: () async {
          bool isUpdate = await CharacterDetailPage.start(context, character);
          RSLogger.d('詳細画面でステータスが更新されたか？ $isUpdate');
          if (isUpdate) {
            await refreshListener();
          }
        },
      ),
    );
  }

  Widget _viewLeadingArea(BuildContext context) {
    return Row(
      children: [
        CharacterIcon.normal(character.getShowIconPath()),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(character.name, style: Theme.of(context).textTheme.subtitle1),
              Text(character.production, style: Theme.of(context).textTheme.caption),
            ],
          ),
        ),
      ],
    );
  }

  Widget _viewTrailingArea(BuildContext context) {
    return Row(
      children: [
        WeaponIcon.small(character.weapons.first.type),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          child: _viewHpAndTotalStatus(),
        ),
      ],
    );
  }

  Widget _viewHpAndTotalStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${RSStrings.hpName} ${character.myStatus?.hp ?? 0}',
          style: const TextStyle(color: RSColors.hpOnList),
        ),
        Text('${RSStrings.characterTotalStatus} ${character.myStatus?.sumWithoutHp() ?? 0}'),
      ],
    );
  }
}
