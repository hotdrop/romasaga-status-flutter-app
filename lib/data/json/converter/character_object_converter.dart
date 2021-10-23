import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/data/json/object/character_object.dart';
import 'package:rsapp/data/json/object/style_object.dart';

class CharacterObjectConverter implements JsonConverter<CharacterObject, Map<String, dynamic>> {
  const CharacterObjectConverter();

  @override
  CharacterObject fromJson(Map<String, dynamic> json) {
    return CharacterObject(
      id: json['id'] as int,
      name: json['name'] as String,
      weaponTypeName: json['weapon_type'] as String,
      attributeNames: (json['attributes'] as List).map((dynamic o) => o as String).toList(),
      production: json['production'] as String,
      styles: (json['styles'] as List).map((dynamic o) => StyleObject.fromJson(o as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson(CharacterObject obj) => obj.toJson();
}
