import 'dart:io';
import 'package:flutter/services.dart';

import '../../model/base_status.dart';

class BaseStatusApi {
  BaseStatusApi._();
  static final BaseStatusApi _instance = BaseStatusApi._();

  factory BaseStatusApi() {
    return _instance;
  }

  Future<List<BaseStatus>> findAll() async {
    try {
      return await rootBundle.loadStructuredData('res/base_status.txt', (String allLine) async {
        return _convert(allLine);
      });
    } on IOException catch (e) {
      print('Error! $e');
      throw e;
    }
  }

  List<BaseStatus> _convert(String allLine) {
    final lines = allLine.split("\n");
    final List<BaseStatus> results = [];

    for (var line in lines) {
      final items = line.split(',');

      if (items.length < 2) {
        print('[debug] error not split size less than 2. items size = ${items.length} line = $line');
        continue;
      }

      results.add(BaseStatus(items[0], int.parse(items[1]), int.parse(items[2])));
    }

    return results;
  }
}
