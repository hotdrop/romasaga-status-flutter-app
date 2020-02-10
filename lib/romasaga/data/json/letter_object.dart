import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../../model/letter.dart';

import '../../common/rs_logger.dart';

@JsonSerializable()
class LettersJsonObject {
  const LettersJsonObject._(this._letters);

  factory LettersJsonObject.fromJson(dynamic json) {
    if (json == null) {
      RSLogger.d("letter jsonがnullです。");
      return null;
    }
    return LettersJsonObject._(
      (json['letters'] as List)?.map((dynamic o) => LetterJsonObject.fromJson(o as Map<String, dynamic>))?.toList(),
    );
  }

  final List<LetterJsonObject> _letters;

  static List<Letter> parse(String json) {
    final dynamic jsonMap = jsonDecode(json);
    final results = LettersJsonObject.fromJson(jsonMap);
    RSLogger.d('Letterをパースしました。 size=${results._letters.length}');

    return _toModels(results);
  }

  static List<Letter> _toModels(LettersJsonObject obj) {
    return obj._letters
        .map((o) => Letter(
              year: o.year,
              month: o.month,
              title: o.title,
              shortTitle: o.shortTitle,
              imagePath: o.imagePath,
              staticImagePath: o.staticImagePath,
            ))
        .toList();
  }
}

@JsonSerializable()
class LetterJsonObject {
  const LetterJsonObject(this.year, this.month, this.title, this.shortTitle, this.imagePath, this.staticImagePath);

  LetterJsonObject.fromJson(Map<String, dynamic> json)
      : year = json['year'] as int,
        month = json['month'] as int,
        title = json['title'] as String,
        shortTitle = json['short_title'] as String,
        imagePath = json['image_path'] as String,
        staticImagePath = json['static_image_path'] as String;

  final int year;
  final int month;
  final String title;
  final String shortTitle;
  final String imagePath;
  final String staticImagePath;
}
