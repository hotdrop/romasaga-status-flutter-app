import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/romasaga/data/json/converter/LetterObjectConverter.dart';

part 'letter_object.freezed.dart';
part 'letter_object.g.dart';

@freezed
abstract class LetterObject with _$LetterObject {
  const factory LetterObject({
    @required int year,
    @required int month,
    @required String title,
    @required String shortTitle,
    @required String imageName,
  }) = _LetterObject;

  const LetterObject._();

  factory LetterObject.fromJson(Map<String, dynamic> json) => converter.fromJson(json);

  static const converter = LetterObjectConverter();
}
