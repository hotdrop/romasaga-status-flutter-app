import 'package:flutter/material.dart';

import '../model/character.dart';
import 'detail/char_detail_page.dart';

class CharListRowItem extends StatelessWidget {
  final Character character;
  final int index;

  const CharListRowItem({this.character, this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  // TODO 画像どうやって持ってくるか・・
                  child: Text(character.name[0]),
                ),
              ),
              // TODO キャラの武器種別、カテゴリー、持っているかどうかのアイコンも表示する。
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    character.name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text('${character.toStringRanks}')
                ],
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharDetailPage(
                    character: character,
                  ),
            ),
          );
        },
      ),
    );
  }
}
