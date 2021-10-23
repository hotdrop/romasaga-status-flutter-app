import 'dart:convert';

import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/json/object/letter_object.dart';
import 'package:rsapp/models/letter.dart';

class LetterJson {
  ///
  /// 他のjsonクラスと異なり、アイコンファイルのパスをモデルクラスに設定する必要があるので
  /// parseとtoModelメソッドを分けている。
  ///
  static List<Letter> parse(String json) {
    dynamic jsonMap = jsonDecode(json);
    final objList = (jsonMap['letters'] as List) //
        .map((dynamic o) => LetterObject.fromJson(o as Map<String, dynamic>))
        .toList();
    RSLogger.d('リモートから取得したjsonをパースしました。 size=${objList.length}');

    return objList.map((e) => _jsonObjectToLetter(e)).toList();
  }

  static Letter _jsonObjectToLetter(LetterObject obj) {
    return Letter(
      year: obj.year,
      month: obj.month,
      title: obj.title,
      shortTitle: obj.shortTitle,
      fileName: obj.imageName,
    );
  }
}
