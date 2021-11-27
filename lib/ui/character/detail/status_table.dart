import 'package:flutter/material.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class StatusTable extends StatelessWidget {
  const StatusTable({
    Key? key,
    required this.character,
    required this.ranks,
    required this.stage,
  }) : super(key: key);

  final Character character;
  final List<String> ranks;
  final Stage stage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _viewTitle(),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _viewTable(context),
        ),
      ],
    );
  }

  Widget _viewTitle() {
    return const Text(
      RSStrings.detailPageStatusTableLabel,
      style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline),
    );
  }

  Widget _viewTable(BuildContext context) {
    final side = BorderSide(color: Theme.of(context).dividerColor, width: 1.0, style: BorderStyle.solid);
    return Table(
      border: TableBorder(bottom: side, horizontalInside: side),
      defaultColumnWidth: const FixedColumnWidth(40.0),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        _rowHeader(context),
        ..._rowStatus(context),
      ],
    );
  }

  TableRow _rowHeader(BuildContext context) {
    return const TableRow(
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
    );
  }

  List<TableRow> _rowStatus(BuildContext context) {
    int maxStr = 0;
    int maxVit = 0;
    int maxAgi = 0;
    int maxDex = 0;
    int maxInt = 0;
    int maxSpi = 0;
    int maxLove = 0;
    int maxAttr = 0;

    for (var rank in ranks) {
      final style = character.getStyle(rank);
      maxStr = (style.str > maxStr) ? style.str : maxStr;
      maxVit = (style.vit > maxVit) ? style.vit : maxVit;
      maxAgi = (style.agi > maxAgi) ? style.agi : maxAgi;
      maxDex = (style.dex > maxDex) ? style.dex : maxDex;
      maxInt = (style.intelligence > maxInt) ? style.intelligence : maxInt;
      maxSpi = (style.spirit > maxSpi) ? style.spirit : maxSpi;
      maxLove = (style.love > maxLove) ? style.love : maxLove;
      maxAttr = (style.attr > maxAttr) ? style.attr : maxAttr;
    }

    final List<TableRow> tableRows = [];
    final int stageStatusLimit = stage.statusLimit;

    for (var rank in ranks) {
      final style = character.getStyle(rank);
      final tableRow = TableRow(
        children: [
          _TableRowIcon(style.iconFilePath),
          _TableRowStatus(style.str, stageStatusLimit, maxStr),
          _TableRowStatus(style.vit, stageStatusLimit, maxVit),
          _TableRowStatus(style.agi, stageStatusLimit, maxAgi),
          _TableRowStatus(style.dex, stageStatusLimit, maxDex),
          _TableRowStatus(style.intelligence, stageStatusLimit, maxInt),
          _TableRowStatus(style.spirit, stageStatusLimit, maxSpi),
          _TableRowStatus(style.love, stageStatusLimit, maxLove),
          _TableRowStatus(style.attr, stageStatusLimit, maxAttr),
        ],
      );
      tableRows.add(tableRow);
    }
    return tableRows;
  }
}

class _TableRowHeader extends StatelessWidget {
  const _TableRowHeader(this.title, {Key? key}) : super(key: key);

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
  const _TableRowIcon(this.iconFilePath, {Key? key}) : super(key: key);

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
  const _TableRowStatus(
    this.status,
    this.stageStatusLimit,
    this.maxStatus, {
    Key? key,
  }) : super(key: key);

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
