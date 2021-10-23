import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/data/json/converter/character_object_converter.dart';
import 'package:rsapp/data/json/object/style_object.dart';

part 'character_object.freezed.dart';
part 'character_object.g.dart';

///
/// キャラクターのJsonオブジェクト
///
@freezed
class CharacterObject with _$CharacterObject {
  factory CharacterObject({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'weapon_type') required String weaponTypeName,
    @JsonKey(name: 'attributes') List<String>? attributeNames,
    @JsonKey(name: 'production') required String production,
    @JsonKey(name: 'styles') required List<StyleObject> styles,
  }) = _CharacterObject;

  factory CharacterObject.fromJson(Map<String, dynamic> json) => converter.fromJson(json);

  static const converter = CharacterObjectConverter();
}
