import 'package:flutter/material.dart';
import 'package:rsapp/romasaga/common/rs_colors.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/ui/widget/rs_icon.dart';

class RankChoiceChip extends StatefulWidget {
  const RankChoiceChip({this.ranks, this.initSelectedRank, this.onSelectedListener});

  final List<String> ranks;
  final String initSelectedRank;
  final void Function(String) onSelectedListener;

  @override
  _RankChoiceChipState createState() => _RankChoiceChipState(ranks, initSelectedRank, onSelectedListener);
}

class _RankChoiceChipState extends State<RankChoiceChip> {
  _RankChoiceChipState(this._ranks, this._initSelectedRank, this._listener) {
    _selectedRankChipName = _initSelectedRank;
  }

  final List<String> _ranks;
  final String _initSelectedRank;
  final void Function(String) _listener;

  String _selectedRankChipName;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 4.0,
      children: _rankChips(context),
    );
  }

  List<Widget> _rankChips(BuildContext context) {
    return _ranks.map<Widget>((rank) {
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: ChoiceChip(
          key: ValueKey(rank),
          selectedColor: _rankColor(rank),
          backgroundColor: Theme.of(context).disabledColor,
          label: Text(rank),
          avatar: _rankIcon(rank),
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

  Color _rankColor(String rank) {
    if (rank.contains(RSStrings.rankSS)) {
      return RSColors.chipRankSS;
    } else if (rank.contains(RSStrings.rankS)) {
      return RSColors.chipRankS;
    } else {
      return RSColors.chipRankA;
    }
  }

  CircleAvatar _rankIcon(String rank) {
    return CircleAvatar(
      backgroundColor: RSColors.chipAvatarBackground,
      child: StyleRankIcon.create(rank),
    );
  }
}
