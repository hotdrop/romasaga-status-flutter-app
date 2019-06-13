import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../model/character.dart';

class RomasagaFile {
  final _styles = Map<String, Character>();

  Future<List<Character>> read() async {
    try {
      await rootBundle.loadStructuredData('res/romasaga.txt', (String allLine) async {
        final lines = allLine.split("\n");
        for (var line in lines) {
          _convert(line);
        }
      });
//      var file = File('res/romasaga.txt');
//      final inputStream = await file.readAsLines(encoding: utf8);
//      for (var line in inputStream) {
//        _convert(line);
//      }
      return _styles.values.toList();
    } on IOException catch (e) {
      print('Error! $e');
      throw e;
    }
  }

  void _convert(String line) {
    final items = line.split('	');

    if (items.length < 9) {
      print('[debug] error not split size less than 9. items sie = ${items.length} line = $line');
    }

    final nameWithRank = items[0];
    final name = _takeName(nameWithRank);
    final rank = _takeRank(nameWithRank);

    final str = int.parse(items[1]);
    final vit = int.parse(items[2]);
    final dex = int.parse(items[3]);
    final agi = int.parse(items[4]);
    final inte = int.parse(items[5]);
    final spi = int.parse(items[6]);
    final love = int.parse(items[7]);
    final attr = int.parse(items[8]);

//    print('[debug] create character style $name [$rank]');

    if (_styles.containsKey(name)) {
      var c = _styles[name];
      c.addStyle(rank, str, vit, dex, agi, inte, spi, love, attr);
      _styles.update(name, (dynamic val) => c);
    } else {
      var c = Character(name);
      c.addStyle(rank, str, vit, dex, agi, inte, spi, love, attr);
      _styles[name] = c;
    }
  }

  String _takeRank(String nameWithRank) {
    final secondKakko = nameWithRank.indexOf(')');
    return nameWithRank.substring(1, secondKakko);
  }

  String _takeName(String nameWithRank) {
    final secondKakko = nameWithRank.indexOf(')');
    return nameWithRank.substring(secondKakko + 1, nameWithRank.length);
  }
}
