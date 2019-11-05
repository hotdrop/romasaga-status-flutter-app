import 'package:flutter/material.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

import 'rs_icon.dart';

class RankChoiceChip extends StatefulWidget {
  const RankChoiceChip({this.ranks, this.initSelectedRank, this.onSelectedListener});

  final List<String> ranks;
  final String initSelectedRank;
  final Function(String) onSelectedListener;

  @override
  _RankChoiceChipState createState() => _RankChoiceChipState(ranks, initSelectedRank, onSelectedListener);
}

class _RankChoiceChipState extends State<RankChoiceChip> {
  _RankChoiceChipState(this._ranks, this._initSelectedRank, this._listener) {
    _selectedRankChipName = _initSelectedRank;
  }

  final List<String> _ranks;
  final String _initSelectedRank;
  final Function(String) _listener;

  String _selectedRankChipName;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 4.0,
      children: _rankChips(),
    );
  }

  List<Widget> _rankChips() {
    return _ranks.map<Widget>((rank) {
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: ChoiceChip(
          key: ValueKey(rank),
          selectedColor: _rankToColor(rank),
          backgroundColor: RSColors.iconBackground,
          label: Text(rank),
          avatar: _rankToAvatar(rank),
          selected: _selectedRankChipName == rank,
          onSelected: (value) {
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
    if (rank.contains(RSStrings.rankSS)) {
      return RSColors.chipRankSS;
    } else if (rank.contains(RSStrings.rankS)) {
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
