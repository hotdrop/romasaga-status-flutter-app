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
      body: Center(
        child: Text("${character.name} の画面です。"),
      ),
    );
  }
}
