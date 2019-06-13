import 'dart:io';
import 'package:flutter/services.dart';

import '../model/character.dart';

class LocalDataSource {
  Future<List<Character>> findAll() async {
    try {
      return await rootBundle.loadStructuredData('res/romasaga.txt', (String allLine) async {
        return _convert(allLine);
      });
    } on IOException catch (e) {
      print('Error! $e');
      throw e;
    }
  }

  List<Character> _convert(String allLine) {
    final lines = allLine.split("\n");
    final styleMap = Map<String, Character>();

    for (var line in lines) {
      final items = line.split('	');

      if (items.length < 9) {
        print('[debug] error not split size less than 9. items sie = ${items.length} line = $line');
        continue;
      }

      final nameWithRank = items[0];
      final name = _takeName(nameWithRank);
      final rank = _takeRank(nameWithRank);

      final str = int.parse(items[1]);
      final vit = int.parse(items[2]);
      final dex = int.parse(items[3]);
      final agi = int.parse(items[4]);
      final intelligence = int.parse(items[5]);
      final spi = int.parse(items[6]);
      final love = int.parse(items[7]);
      final attr = int.parse(items[8]);

      if (styleMap.containsKey(name)) {
        var c = styleMap[name];
        c.addStyle(rank, str, vit, dex, agi, intelligence, spi, love, attr);
        styleMap.update(name, (dynamic val) => c);
      } else {
        var c = Character(name);
        c.addStyle(rank, str, vit, dex, agi, intelligence, spi, love, attr);
        styleMap[name] = c;
      }
    }

    return styleMap.values.toList();
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
