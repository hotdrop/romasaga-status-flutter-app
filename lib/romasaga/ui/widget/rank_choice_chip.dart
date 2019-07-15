import 'package:flutter/material.dart';

import '../../model/character.dart' show Style;
import 'romasaga_icon.dart';

@immutable
class RankChoiceChip extends StatefulWidget {
  const RankChoiceChip({this.ranks, this.onSelectedListener});

  final List<String> ranks;
  final Function(String) onSelectedListener;

  @override
  _RankChoiceChipState createState() => _RankChoiceChipState(ranks, onSelectedListener);
}

class _RankChoiceChipState extends State<RankChoiceChip> {
  final List<String> _ranks;
  final Function(String) _listener;

  String _selectedRankChipName;

  _RankChoiceChipState(this._ranks, this._listener) {
    _selectedRankChipName = _ranks.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
            _listener(rank);
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
      child: RomasagaIcon.rankSmallSize(rank),
    );
  }
}
