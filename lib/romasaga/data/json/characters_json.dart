import 'dart:convert';

import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/json/object/character_object.dart';
import 'package:rsapp/romasaga/data/json/object/style_object.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';

class CharactersJson {
  static List<Character> parse(String json) {
    final dynamic jsonMap = jsonDecode(json);
    final objList = (jsonMap['characters'] as List).map((dynamic o) => CharacterObject.fromJson(o as Map<String, dynamic>))?.toList();
    RSLogger.d('リモートから取得したjsonをパースしました。 size=${objList.length}');

    final characters = <Character>[];
    for (var obj in objList) {
      final c = _jsonObjectToCharacter(obj);
      if (characters.any((result) => result.id == c.id)) {
        throw FormatException('キャラ${c.name}のidが重複しています。jsonを見直してください。id=${c.id}');
      }
      characters.add(c);
    }
    return characters;
  }

  static Character _jsonObjectToCharacter(CharacterObject obj) {
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

  static Style _jsonObjectToStyle(int characterId, StyleObject obj) {
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
