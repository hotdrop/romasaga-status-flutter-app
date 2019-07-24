import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'response/character_json_object.dart';
import '../../model/character.dart';
import '../../model/style.dart';

import '../../common/saga_logger.dart';

class CharacterApi {
  static final CharacterApi _instance = CharacterApi._();

  const CharacterApi._();
  factory CharacterApi() {
    return _instance;
  }

  Future<List<Character>> findAll() async {
    try {
      // TODO ここ本当はAPIとかFirestoreからデータ取得したい
      return await rootBundle.loadStructuredData('res/json/characters.json', (String json) async {
        final jsonObjects = _parseJson(json);
        return _jsonObjectToModel(jsonObjects);
      });
    } on IOException catch (e) {
      SagaLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }

  CharactersJsonObject _parseJson(String json) {
    final jsonMap = jsonDecode(json);
    final results = CharactersJsonObject.fromJson(jsonMap);
    SagaLogger.d("Characterをパースしました。 size=${results.characters.length}");
    return results;
  }

  List<Character> _jsonObjectToModel(CharactersJsonObject obj) {
    final characters = <Character>[];
    for (var charObj in obj.characters) {
      var character = Character(charObj.id, charObj.name, charObj.production, charObj.weaponType);
      for (var styleObj in charObj.styles) {
        var style = _jsonObjectToStyleModel(character.id, styleObj);
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

  Style _jsonObjectToStyleModel(int characterId, StyleJsonObject obj) {
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
