import 'dart:io';
import 'package:flutter/services.dart';

import '../../model/stage.dart';

class StageApi {
  static final StageApi _instance = StageApi._();

  const StageApi._();
  factory StageApi() {
    return _instance;
  }

  Future<List<Stage>> findAll() async {
    try {
      // TODO ここ本当はAPIとかFirestoreからデータ取得したい
      return await rootBundle.loadStructuredData('res/status_upper_limit.txt', (String allLine) async {
        return _convert(allLine);
      });
    } on IOException catch (e) {
      print('Error! $e');
      throw e;
    }
  }

  List<Stage> _convert(String allLine) {
    final lines = allLine.split("\n");
    final List<Stage> results = [];

    for (var line in lines) {
      final items = line.split(',');

      if (items.length < 2) {
        // TODO ロガーライブラリ使うべき。Timberみたいなのが欲しい
        print('[debug] error not split size less than 2. items size = ${items.length} line = $line');
        continue;
      }

      results.add(Stage(items[0], int.parse(items[1]), int.parse(items[2])));
    }

    return results;
  }
}
