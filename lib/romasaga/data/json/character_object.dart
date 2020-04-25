import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/model/attribute.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/style.dart';
import 'package:rsapp/romasaga/model/weapon.dart';

@JsonSerializable()
class CharactersJsonObject {
  const CharactersJsonObject._(this._jsonObjects);

  factory CharactersJsonObject._fromJson(dynamic json) {
    if (json == null) {
      RSLogger.d('Character jsonがnullです。');
      return null;
    }

    final characters = (json['characters'] as List);
    final jsonObjects = characters.map((dynamic o) => CharacterJsonObject.fromJson(o as Map<String, dynamic>))?.toList();

    return CharactersJsonObject._(jsonObjects);
  }

  final List<CharacterJsonObject> _jsonObjects;

  static List<Character> parseToObjects(String json) {
    final dynamic jsonMap = jsonDecode(json);
    final characterJsonObject = CharactersJsonObject._fromJson(jsonMap);
    RSLogger.d('リモートから取得したjsonをパースしました。 size=${characterJsonObject._jsonObjects.length}');

    final results = <Character>[];
    for (var charObj in characterJsonObject._jsonObjects) {
      final c = _jsonObjectToCharacter(charObj);
      if (results.any((result) => result.id == c.id)) {
        throw FormatException('キャラ${c.name}のidが重複しています。jsonを見直してください。id=${c.id}');
      }
      results.add(c);
    }
    return results;
  }

  static Character _jsonObjectToCharacter(CharacterJsonObject obj) {
    Character character;
    bool haveAttribute = obj.attributeNames?.isNotEmpty ?? false;
    if (haveAttribute) {
      character = Character(
        obj.id,
        obj.name,
        obj.production,
        Weapon(name: obj.weaponTypeName),
        attributes: obj.attributeNames.map((v) => Attribute(name: v)).toList(),
      );
    } else {
      character = Character(obj.id, obj.name, obj.production, Weapon(name: obj.weaponTypeName));
    }

    for (var styleObj in obj.styles) {
      final style = _jsonObjectToStyle(character.id, styleObj);
      character.addStyle(style);

      if (character.selectedStyleRank == null) {
        character.selectedStyleRank = style.rank;
      }
    }

    return character;
  }

  static Style _jsonObjectToStyle(int characterId, StyleJsonObject obj) {
    return Style(
      characterId,
      obj.rank,
      obj.title,
      obj.iconFileName,
      obj.str,
      obj.vit,
      obj.dex,
      obj.agi,
      obj.intelligence,
      obj.spi,
      obj.love,
      obj.attr,
    );
  }
}

///
/// キャラクターのJsonオブジェクト
///
@JsonSerializable()
class CharacterJsonObject {
  CharacterJsonObject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        weaponTypeName = json['weapon_type'] as String,
        attributeNames = (json['attributes'] as List)?.map((dynamic o) => o as String)?.toList(),
        production = json['production'] as String,
        styles = (json['styles'] as List)?.map((dynamic o) => StyleJsonObject.fromJson(o as Map<String, dynamic>))?.toList();

  final int id;
  final String name;
  final String weaponTypeName;
  final List<String> attributeNames;
  final String production;
  final List<StyleJsonObject> styles;
}

///
/// キャラクタースタイルのJsonオブジェクト
///
@JsonSerializable()
class StyleJsonObject {
  const StyleJsonObject(
    this.rank,
    this.title,
    this.str,
    this.vit,
    this.dex,
    this.agi,
    this.intelligence,
    this.spi,
    this.love,
    this.attr,
    this.iconFileName,
  );

  StyleJsonObject.fromJson(Map<String, dynamic> json)
      : rank = json['rank'] as String,
        title = json['title'] as String,
        str = json['str'] as int,
        vit = json['vit'] as int,
        dex = json['dex'] as int,
        agi = json['agi'] as int,
        intelligence = json['int'] as int,
        spi = json['spi'] as int,
        love = json['love'] as int,
        attr = json['attr'] as int,
        iconFileName = json['icon'] as String;

  final String rank;
  final String title;
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int intelligence;
  final int spi;
  final int love;
  final int attr;
  final String iconFileName;

  static const int itemLength = 11;
}
