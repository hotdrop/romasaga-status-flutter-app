import 'dart:io';
import 'package:flutter/services.dart';
import 'package:rsapp/romasaga/data/json/letter_object.dart';

import '../../model/letter.dart';
import '../../common/rs_logger.dart';

class LetterDao {
  const LetterDao._();

  factory LetterDao.create() {
    return LetterDao._();
  }

  static String _localJsonPath = 'res/json/letters.json';

  Future<List<Letter>> findAll() async {
    try {
      return await rootBundle.loadStructuredData(_localJsonPath, (json) async {
        return LettersJsonObject.parse(json);
      });
    } on IOException catch (e) {
      RSLogger.e('お便りデータの取得時にエラーが発生しました。', e);
      rethrow;
    }
  }
}
