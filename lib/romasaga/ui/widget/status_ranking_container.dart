import 'package:flutter/material.dart';
import 'package:rsapp/romasaga/common/rs_colors.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/status.dart';
import 'package:rsapp/romasaga/ui/widget/rs_icon.dart';

class StatusRankingContainer extends StatelessWidget {
  const StatusRankingContainer(this._type, this._characters)
      : assert(_characters != null, 'A non-null ranking Characters must be provided to this widget'),
        assert(_characters.length == 5, 'ranking character length must be 5.');

  final StatusType _type;
  final List<Character> _characters;

  @override
  Widget build(BuildContext context) {
    final mainColor = _mainColor();
    final thinColor = _thinColor();

    return Stack(
      children: <Widget>[
        Container(
          width: 150.0,
          height: 270.0,
          margin: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: mainColor.withOpacity(0.6),
                offset: Offset(1.1, 4.0),
                blurRadius: 8.0,
              ),
            ],
            gradient: LinearGradient(
              colors: [mainColor, mainColor, mainColor, mainColor, thinColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _contentsRanking(),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 16.0,
          child: _getStatusIcon(),
        )
      ],
    );
  }

  List<Widget> _contentsRanking() {
    return <Widget>[
      _rowStatusRanking(_characters[0], RankingIcon.createFirst()),
      const SizedBox(height: 8.0),
      _rowStatusRanking(_characters[1], RankingIcon.createSecond()),
      const SizedBox(height: 8.0),
      _rowStatusRanking(_characters[2], RankingIcon.createThird()),
      const SizedBox(height: 8.0),
      _rowStatusRanking(_characters[3], RankingIcon.createFourth()),
      const SizedBox(height: 8.0),
      _rowStatusRanking(_characters[4], RankingIcon.createFifth()),
    ];
  }

  Widget _rowStatusRanking(Character character, RankingIcon rankingIcon) {
    return Row(
      children: <Widget>[
        rankingIcon,
        SizedBox(width: 8.0),
        CharacterIcon.small(character.selectedIconFilePath),
        SizedBox(width: 8.0),
        Text(_targetStatus(character)),
      ],
    );
  }

  Widget _getStatusIcon() {
    switch (_type) {
      case StatusType.str:
        return StatusIcon.str();
      case StatusType.vit:
        return StatusIcon.vit();
      case StatusType.dex:
        return StatusIcon.dex();
      case StatusType.agi:
        return StatusIcon.agi();
      case StatusType.intelligence:
        return StatusIcon.int();
      case StatusType.spirit:
        return StatusIcon.spirit();
      case StatusType.love:
        return StatusIcon.love();
      default:
        return StatusIcon.attr();
    }
  }

  Color _mainColor() {
    switch (_type) {
      case StatusType.str:
        return RSColors.str;
      case StatusType.vit:
        return RSColors.vit;
      case StatusType.dex:
        return RSColors.dex;
      case StatusType.agi:
        return RSColors.agi;
      case StatusType.intelligence:
        return RSColors.int;
      case StatusType.spirit:
        return RSColors.spirit;
      case StatusType.love:
        return RSColors.love;
      default:
        return RSColors.attr;
    }
  }

  Color _thinColor() {
    switch (_type) {
      case StatusType.str:
        return RSColors.strThin;
      case StatusType.vit:
        return RSColors.vitThin;
      case StatusType.dex:
        return RSColors.dexThin;
      case StatusType.agi:
        return RSColors.agiThin;
      case StatusType.intelligence:
        return RSColors.intThin;
      case StatusType.spirit:
        return RSColors.spiritThin;
      case StatusType.love:
        return RSColors.loveThin;
      default:
        return RSColors.attrThin;
    }
  }

  String _targetStatus(Character character) {
    switch (_type) {
      case StatusType.str:
        return character.myStatus.str.toString();
      case StatusType.vit:
        return character.myStatus.vit.toString();
      case StatusType.dex:
        return character.myStatus.dex.toString();
      case StatusType.agi:
        return character.myStatus.agi.toString();
      case StatusType.intelligence:
        return character.myStatus.intelligence.toString();
      case StatusType.spirit:
        return character.myStatus.spirit.toString();
      case StatusType.love:
        return character.myStatus.love.toString();
      default:
        return character.myStatus.attr.toString();
    }
  }
}
