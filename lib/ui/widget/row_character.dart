import 'package:flutter/material.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/ui/character/detail/character_detail_page.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class RowCharacterItem extends StatelessWidget {
  const RowCharacterItem(this.character, {super.key});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _ViewLeadingArea(
                iconPath: character.getShowIconPath(),
                name: character.name,
                production: character.production,
              ),
              _ViewTrailingArea(
                weaponType: character.weapons.first.type,
                hp: character.myStatus?.hp ?? 0,
                sumWithoutHp: character.myStatus?.sumWithoutHp() ?? 0,
              ),
            ],
          ),
        ),
        onTap: () async => await _onTap(context),
      ),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    await CharacterDetailPage.start(context, character.id);
  }
}

class _ViewLeadingArea extends StatelessWidget {
  const _ViewLeadingArea({required this.iconPath, required this.name, required this.production});

  final String iconPath;
  final String name;
  final String production;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CharacterIcon.normal(iconPath),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: Theme.of(context).textTheme.titleMedium),
              Text(production, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _ViewTrailingArea extends StatelessWidget {
  const _ViewTrailingArea({required this.weaponType, required this.hp, required this.sumWithoutHp});

  final WeaponType weaponType;
  final int hp;
  final int sumWithoutHp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WeaponIcon.small(weaponType),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${RSStrings.hpName} $hp', style: const TextStyle(color: RSColors.hpOnList)),
              Text('${RSStrings.characterTotalStatus} $sumWithoutHp'),
            ],
          ),
        ),
      ],
    );
  }
}
