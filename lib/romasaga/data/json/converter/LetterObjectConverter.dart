import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/romasaga/data/json/object/letter_object.dart';

class LetterObjectConverter implements JsonConverter<LetterObject, Map<String, dynamic>> {
  const LetterObjectConverter();

  @override
  LetterObject fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return LetterObject(
      year: json['year'] as int,
      month: json['month'] as int,
      title: json['title'] as String,
      shortTitle: json['short_title'] as String,
      imageName: json['image_name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(LetterObject object) => object.toJson();
}
