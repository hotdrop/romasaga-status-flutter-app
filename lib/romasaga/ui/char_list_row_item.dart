import 'package:flutter/material.dart';

import '../model/character.dart';

class CharListRowItem extends StatelessWidget {
  final Character character;
  final int index;

  const CharListRowItem({this.character, this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(character.name[0]),
              ),
            ),
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
    );
  }
}
