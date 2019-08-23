import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../../model/character.dart';
import '../../model/style.dart';

import '../../common/rs_logger.dart';

@JsonSerializable()
class CharactersJsonObject {
  final List<CharacterJsonObject> characters;

  const CharactersJsonObject({this.characters});

  factory CharactersJsonObject.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      RSLogger.d("Character jsonがnullです。");
      return null;
    }
    return CharactersJsonObject(
      characters: (json['characters'] as List)?.map((o) => CharacterJsonObject.fromJson(o as Map<String, dynamic>))?.toList(),
    );
  }

  static CharactersJsonObject parse(String json) {
    final jsonMap = jsonDecode(json);
    final results = CharactersJsonObject.fromJson(jsonMap);
    RSLogger.d("Characterをパースしました。 size=${results.characters.length}");
    return results;
  }

  static List<Character> toModel(CharactersJsonObject obj) {
    final characters = <Character>[];
    for (var charObj in obj.characters) {
      final character = Character(charObj.id, charObj.name, charObj.production, charObj.weaponType);
      for (var styleObj in charObj.styles) {
        final style = _jsonObjectToStyleModel(character.id, styleObj);
        character.addStyle(style);
        if (character.selectedStyleRank == null) {
          character.selectedStyleRank = style.rank;
          character.selectedIconFileName = style.iconFileName;
        }
      }
      characters.add(character);
    }
    return characters;
  }

  static Style _jsonObjectToStyleModel(int characterId, StyleJsonObject obj) {
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

@JsonSerializable()
class CharacterJsonObject {
  final int id;
  final String name;
  final String weaponType;
  final String production;
  final List<StyleJsonObject> styles;

  const CharacterJsonObject(this.id, this.name, this.weaponType, this.production, this.styles);

  CharacterJsonObject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        weaponType = json['weapon_type'] as String,
        production = json['production'] as String,
        styles = (json['styles'] as List)?.map((o) => StyleJsonObject.fromJson(o as Map<String, dynamic>))?.toList();
}

@JsonSerializable()
class StyleJsonObject {
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
}
