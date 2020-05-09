import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LetterJsonObject {
  LetterJsonObject._fromJson(Map<String, dynamic> json)
      : year = json['year'] as int,
        month = json['month'] as int,
        title = json['title'] as String,
        shortTitle = json['short_title'] as String,
        _imageName = json['image_name'] as String;

  final int year;
  final int month;
  final String title;
  final String shortTitle;
  final String _imageName;

  String get gifFileName => '$_imageName.gif';
  String get staticImageFileName => '${_imageName}_static.jpg';

  static List<LetterJsonObject> parseToObjects(String json) {
    dynamic jsonMap = jsonDecode(json);
    if (jsonMap == null) {
      throw Exception('jsonのデコード結果がnullでした。');
    }
    return (jsonMap['letters'] as List)?.map((dynamic o) => LetterJsonObject._fromJson(o as Map<String, dynamic>))?.toList();
  }
}
