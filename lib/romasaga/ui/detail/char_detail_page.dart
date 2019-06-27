import 'package:flutter/material.dart';

import '../../model/character.dart';

class CharDetailPage extends StatelessWidget {
  final Character character;

  CharDetailPage({Key key, @required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("キャラクター詳細"),
      ),
      // TODO レイアウト決める
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[_buildNameField(context), _buildStatusTable(context)],
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "${character.name}",
            style: Theme.of(context).textTheme.subhead,
          ),
        )
      ],
    );
  }

  Widget _buildStatusTable(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _createTable(),
    );
  }

  List<Widget> _createTable() {
    List<Widget> list = [];

    final header = Row(
      children: <Widget>[
        _createTableHeaderData(""),
        _createTableHeaderData("腕"),
        _createTableHeaderData("体"),
        _createTableHeaderData("器"),
        _createTableHeaderData("早"),
        _createTableHeaderData("知"),
        _createTableHeaderData("精"),
        _createTableHeaderData("愛"),
        _createTableHeaderData("魅"),
      ],
    );
    list.add(header);

    character.styles.forEach((style) {
      final rowData = Row(
        children: <Widget>[
          _createTableData(style.rank),
          _createTableData(style.str.toString()),
          _createTableData(style.vit.toString()),
          _createTableData(style.dex.toString()),
          _createTableData(style.agi.toString()),
          _createTableData(style.intelligence.toString()),
          _createTableData(style.spirit.toString()),
          _createTableData(style.love.toString()),
          _createTableData(style.attr.toString()),
        ],
      );
      list.add(rowData);
    });

    return list;
  }

  Expanded _createTableHeaderData(String s) {
    return Expanded(child: Container(child: Text(s)));
  }

  Expanded _createTableData(String s) {
    return Expanded(child: Container(child: Text(s)));
  }
}
