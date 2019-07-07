import 'dart:io';
import 'package:flutter/services.dart';

import '../../model/character.dart';
import '../../model/my_status.dart';

class RomasagaApi {
  static final RomasagaApi _instance = RomasagaApi._();

  const RomasagaApi._();
  factory RomasagaApi() {
    return _instance;
  }

  Future<List<Character>> findAll() async {
    try {
      // TODO ここ本当はAPIとかFirestoreからデータ取得したい
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
      final items = line.split(',');

      if (items.length < 13) {
        // TODO ロガーライブラリ使うべき。Timberみたいなのが欲しい
        print('[debug] error not split size less than 13. items size = ${items.length} line = $line');
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
      final weaponType = items[9];
      final title = items[10];
      final production = items[11];
      final iconFileName = items[12];

      if (styleMap.containsKey(name)) {
        var c = styleMap[name];
        c.addStyle(rank, str, vit, dex, agi, intelligence, spi, love, attr);
        styleMap.update(name, (dynamic val) => c);
      } else {
        // TODO これダミー
        final status = MyStatus.empty();
        var c = Character(name, title, production, weaponType, status, iconFileName);
        c.addStyle(rank, str, vit, dex, agi, intelligence, spi, love, attr);
        styleMap[name] = c;
      }
    }

    return styleMap.values.toList();
  }

  String _takeRank(String nameWithRank) {
    final secondBrackets = nameWithRank.indexOf(')');
    return nameWithRank.substring(1, secondBrackets);
  }

  String _takeName(String nameWithRank) {
    final secondBrackets = nameWithRank.indexOf(')');
    return nameWithRank.substring(secondBrackets + 1, nameWithRank.length);
  }
}
