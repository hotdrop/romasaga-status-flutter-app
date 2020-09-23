import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rsapp/romasaga/data/json/object/letter_object.dart';
import 'package:rsapp/romasaga/model/letter.dart';

class LetterJson {
  ///
  /// 他のjsonクラスと異なり、アイコンファイルのパスをモデルクラスに設定する必要があるので
  /// parseとtoModelメソッドを分けている。
  ///
  static List<LetterObject> parse(String json) {
    dynamic jsonMap = jsonDecode(json);
    return (jsonMap['letters'] as List)?.map((dynamic o) => LetterObject.fromJson(o as Map<String, dynamic>))?.toList();
  }

  static Letter toModel(LetterObject obj, {@required String gifFilePath, @required String staticImagePath}) {
    return Letter(
      year: obj.year,
      month: obj.month,
      title: obj.title,
      shortTitle: obj.shortTitle,
      gifFilePath: gifFilePath,
      staticImagePath: staticImagePath,
    );
  }
}
