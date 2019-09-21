import 'package:flutter/material.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

import 'rs_icon.dart';

class RankChoiceChip extends StatefulWidget {
  final List<String> ranks;
  final String initSelectedRank;
  final Function(String) onSelectedListener;

  const RankChoiceChip({this.ranks, this.initSelectedRank, this.onSelectedListener});

  @override
  _RankChoiceChipState createState() => _RankChoiceChipState(ranks, initSelectedRank, onSelectedListener);
}

class _RankChoiceChipState extends State<RankChoiceChip> {
  final List<String> _ranks;
  final String _initSelectedRank;
  final Function(String) _listener;

  String _selectedRankChipName;

  _RankChoiceChipState(this._ranks, this._initSelectedRank, this._listener) {
    _selectedRankChipName = _initSelectedRank;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 8.0,
      children: _rankChips(),
    );
  }

  List<Widget> _rankChips() {
    return _ranks.map<Widget>((String rank) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          key: ValueKey(rank),
          selectedColor: _rankToColor(rank),
          backgroundColor: RSColors.chipBackground,
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
    if (rank.contains(RSStrings.RankSS)) {
      return RSColors.chipRankSS;
    } else if (rank.contains(RSStrings.RankS)) {
      return RSColors.chipRankS;
    } else {
      return RSColors.chipRankA;
    }
  }

  CircleAvatar _rankToAvatar(String rank) {
    return CircleAvatar(
      backgroundColor: RSColors.chipAvatarBackground,
      child: RSIcon.rank(rank),
    );
  }
}
