import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class RankChoiceChip extends StatefulWidget {
  const RankChoiceChip({
    Key? key,
    required this.ranks,
    required this.initSelectedRank,
    required this.onSelectedListener,
  }) : super(key: key);

  final List<String> ranks;
  final String initSelectedRank;
  final void Function(String) onSelectedListener;

  @override
  State<RankChoiceChip> createState() => _RankChoiceChipState();
}

class _RankChoiceChipState extends State<RankChoiceChip> {
  _RankChoiceChipState();

  late String _selectedRankChipName;

  @override
  void initState() {
    super.initState();
    _selectedRankChipName = widget.initSelectedRank;
  }

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
    return widget.ranks.map<Widget>((rank) {
      final isSameRank = (_selectedRankChipName == rank);
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: ChoiceChip(
          key: ValueKey(rank),
          selectedColor: _rankColor(rank),
          backgroundColor: Theme.of(context).disabledColor,
          label: Text(rank, style: TextStyle(color: (isSameRank) ? Colors.black : Colors.white)),
          avatar: _rankIcon(rank),
          selected: isSameRank,
          onSelected: (value) {
            setState(() {
              _selectedRankChipName = value ? rank : '';
            });
            widget.onSelectedListener(rank);
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
