import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/romasaga/data/json/converter/CharacterObjectConverter.dart';
import 'package:rsapp/romasaga/data/json/object/style_object.dart';

part 'character_object.freezed.dart';

part 'character_object.g.dart';

///
/// キャラクターのJsonオブジェクト
///
@freezed
abstract class CharacterObject with _$CharacterObject {
  const factory CharacterObject({
    @required int id,
    @required String name,
    @required String weaponTypeName,
    List<String> attributeNames,
    @required String production,
    @required List<StyleObject> styles,
  }) = _CharacterObject;

  factory CharacterObject.fromJson(Map<String, dynamic> json) => converter.fromJson(json);

  static const converter = CharacterObjectConverter();
}
