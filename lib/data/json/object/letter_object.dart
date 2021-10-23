import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/data/json/converter/letter_object_converter.dart';

part 'letter_object.freezed.dart';
// part 'letter_object.g.dart';

@freezed
class LetterObject with _$LetterObject {
  factory LetterObject({
    @JsonKey(name: 'year') required int year,
    @JsonKey(name: 'month') required int month,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'short_title') required String shortTitle,
    @JsonKey(name: 'image_name') required String imageName,
  }) = _LetterObject;

  factory LetterObject.fromJson(Map<String, dynamic> json) => converter.fromJson(json);

  static const converter = LetterObjectConverter();
}
