import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../../common/rs_logger.dart';

import '../../model/character.dart';
import '../../model/style.dart';

@JsonSerializable()
class CharactersJsonObject {
  const CharactersJsonObject._(this._characters);

  factory CharactersJsonObject.fromJson(dynamic json) {
    if (json == null) {
      RSLogger.d('Character jsonがnullです。');
      return null;
    }
    return CharactersJsonObject._(
      (json['characters'] as List)?.map((dynamic o) {
        return CharacterJsonObject.fromJson(o as Map<String, dynamic>);
      })?.toList(),
    );
  }

  final List<CharacterJsonObject> _characters;

  static List<Character> parse(String json) {
    final dynamic jsonMap = jsonDecode(json);
    final results = CharactersJsonObject.fromJson(jsonMap);
    RSLogger.d('リモートから取得したjsonをパースしました。 size=${results._characters.length}');

    return _toModels(results);
  }

  static List<Character> _toModels(CharactersJsonObject obj) {
    final characters = <Character>[];

    for (var charObj in obj._characters) {
      final character = _jsonObjectToCharacter(charObj);
      characters.add(character);
    }
    return characters;
  }

  static Character _jsonObjectToCharacter(CharacterJsonObject obj) {
    final character = Character(obj.id, obj.name, obj.production, obj.weaponType);

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

@JsonSerializable()
class CharacterJsonObject {
  const CharacterJsonObject(this.id, this.name, this.weaponType, this.production, this.styles);

  CharacterJsonObject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        weaponType = json['weapon_type'] as String,
        production = json['production'] as String,
        styles = (json['styles'] as List)?.map((dynamic o) => StyleJsonObject.fromJson(o as Map<String, dynamic>))?.toList();

  final int id;
  final String name;
  final String weaponType;
  final String production;
  final List<StyleJsonObject> styles;
}

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
}
