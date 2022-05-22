import 'package:flutter/material.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class StatusTable extends StatelessWidget {
  const StatusTable({super.key, required this.character, required this.ranks, required this.statusLimit});

  final Character character;
  final List<String> ranks;
  final int statusLimit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          RSStrings.detailPageStatusTableLabel,
          style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _ViewTable(character, ranks, statusLimit),
        ),
      ],
    );
  }
}

class _ViewTable extends StatelessWidget {
  const _ViewTable(this.character, this.ranks, this.statusLimit);

  final Character character;
  final List<String> ranks;
  final int statusLimit;

  @override
  Widget build(BuildContext context) {
    final side = BorderSide(color: Theme.of(context).dividerColor, width: 1.0, style: BorderStyle.solid);

    return Table(
      border: TableBorder(bottom: side, horizontalInside: side),
      defaultColumnWidth: const FixedColumnWidth(40.0),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        const TableRow(
          children: [
            SizedBox(),
            _TableRowHeader(RSStrings.strName),
            _TableRowHeader(RSStrings.vitName),
            _TableRowHeader(RSStrings.agiName),
            _TableRowHeader(RSStrings.dexName),
            _TableRowHeader(RSStrings.intName),
            _TableRowHeader(RSStrings.spiName),
            _TableRowHeader(RSStrings.loveName),
            _TableRowHeader(RSStrings.attrName),
          ],
        ),
        ..._rowStatus(context),
      ],
    );
  }

  List<TableRow> _rowStatus(BuildContext context) {
    _MaxStatus maxState = _MaxStatus();
    for (var rank in ranks) {
      final style = character.getStyle(rank);
      maxState.update(style);
    }

    return ranks.map((r) => character.getStyle(r)).map((s) => _toTableRow(s, statusLimit, maxState)).toList();
  }

  TableRow _toTableRow(Style style, int stageStatusLimit, _MaxStatus maxStatus) {
    return TableRow(
      children: [
        _TableRowIcon(style.iconFilePath),
        _TableRowStatus(style.str, stageStatusLimit, maxStatus.str),
        _TableRowStatus(style.vit, stageStatusLimit, maxStatus.vit),
        _TableRowStatus(style.agi, stageStatusLimit, maxStatus.agi),
        _TableRowStatus(style.dex, stageStatusLimit, maxStatus.dex),
        _TableRowStatus(style.intelligence, stageStatusLimit, maxStatus.inte),
        _TableRowStatus(style.spirit, stageStatusLimit, maxStatus.spi),
        _TableRowStatus(style.love, stageStatusLimit, maxStatus.love),
        _TableRowStatus(style.attr, stageStatusLimit, maxStatus.attr),
      ],
    );
  }
}

class _MaxStatus {
  _MaxStatus();

  int str = 0;
  int vit = 0;
  int agi = 0;
  int dex = 0;
  int inte = 0;
  int spi = 0;
  int love = 0;
  int attr = 0;

  void update(Style style) {
    str = (style.str > str) ? style.str : str;
    vit = (style.vit > vit) ? style.vit : vit;
    agi = (style.agi > agi) ? style.agi : agi;
    dex = (style.dex > dex) ? style.dex : dex;
    inte = (style.intelligence > inte) ? style.intelligence : inte;
    spi = (style.spirit > spi) ? style.spirit : spi;
    love = (style.love > love) ? style.love : love;
    attr = (style.attr > attr) ? style.attr : attr;
  }
}

class _TableRowHeader extends StatelessWidget {
  const _TableRowHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Text(title, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

class _TableRowIcon extends StatelessWidget {
  const _TableRowIcon(this.iconFilePath);

  final String iconFilePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Center(
        child: CharacterIcon.small(iconFilePath),
      ),
    );
  }
}

class _TableRowStatus extends StatelessWidget {
  const _TableRowStatus(this.status, this.stageStatusLimit, this.maxStatus);

  final int status;
  final int stageStatusLimit;
  final int maxStatus;

  @override
  Widget build(BuildContext context) {
    if (status >= maxStatus) {
      return Center(
        child: Text(
          (status + stageStatusLimit).toString(),
          style: const TextStyle(color: RSColors.statusSufficient),
        ),
      );
    } else {
      return Center(
        child: Text((status + stageStatusLimit).toString()),
      );
    }
  }
}
