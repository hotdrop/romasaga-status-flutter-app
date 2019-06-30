import 'package:flutter/material.dart';

import '../../model/character.dart' show Style;
import '../common/romasagaIcon.dart';

class RankChoiceChip extends StatefulWidget {
  final List<String> _ranks;

  RankChoiceChip(this._ranks);

  @override
  _RankChoiceChipState createState() => _RankChoiceChipState(_ranks);
}

class _RankChoiceChipState extends State<RankChoiceChip> {
  List<String> _ranks;
  String _selectedRankChipName;

  _RankChoiceChipState(ranks) {
    _ranks = ranks;
    _selectedRankChipName = '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _rankChips(),
    );
  }

  List<Widget> _rankChips() {
    return _ranks.map<Widget>((String rank) {
      return Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          key: ValueKey(rank),
          selectedColor: _rankToColor(rank),
          backgroundColor: Colors.grey.shade600,
          label: Text(rank),
          avatar: _rankToAvatar(rank),
          selected: _selectedRankChipName == rank,
          onSelected: (bool value) {
            setState(() {
              _selectedRankChipName = value ? rank : '';
            });
            // TODO ここにタップ時の動作が必要・・
          },
        ),
      );
    }).toList();
  }

  Color _rankToColor(String rank) {
    if (rank.contains(Style.rankSS)) {
      return Color.fromARGB(255, 233, 217, 77);
    } else if (rank.contains(Style.rankS)) {
      return Color.fromARGB(255, 200, 204, 219);
    } else {
      return Color.fromARGB(255, 239, 201, 191);
    }
  }

  CircleAvatar _rankToAvatar(String rank) {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade300,
      child: RomasagaIcon.convertRankIconWithSmallSize(rank),
    );
  }
}
