import '../json/character_object.dart';

import '../..//service/rs_service.dart';

import '../../model/character.dart';
import '../../model/style.dart';

import '../../common/rs_logger.dart';

class CharacterApi {
  final RSService _rsService;
  CharacterApi({RSService rsService}) : _rsService = (rsService == null) ? RSService() : rsService;

  Future<List<Character>> findAll() async {
    try {
      String json = await _rsService.readCharactersJson();
      final jsonObjects = CharactersJsonObject.parse(json);

      return await _parse(jsonObjects);
    } catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }

  Future<List<Character>> findByExcludeIds(List<int> ids) async {
    try {
      String json = await _rsService.readCharactersJson();
      final jsonObjects = CharactersJsonObject.parse(json);

      return await _parse(jsonObjects, excludeIds: ids);
    } catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }

  Future<List<Character>> _parse(CharactersJsonObject obj, {List<int> excludeIds}) async {
    final characters = <Character>[];

    for (var charObj in obj.characters) {
      final exist = excludeIds?.contains(charObj.id) ?? false;
      if (exist) {
        continue;
      }

      final character = await _jsonObjectToCharacter(charObj);
      characters.add(character);
    }
    return characters;
  }

  Future<Character> _jsonObjectToCharacter(CharacterJsonObject obj) async {
    final character = Character(obj.id, obj.name, obj.production, obj.weaponType);

    for (var styleObj in obj.styles) {
      final style = await _jsonObjectToStyle(character.id, styleObj);
      character.addStyle(style);

      if (character.selectedStyleRank == null) {
        character.selectedStyleRank = style.rank;
        character.selectedIconFilePath = style.iconFilePath;
      }
    }

    return character;
  }

  Future<Style> _jsonObjectToStyle(int characterId, StyleJsonObject obj) async {
    final iconFilePath = await _rsService.getCharacterIconUrl(obj.iconFileName);
    return Style(
      characterId,
      obj.rank,
      obj.title,
      iconFilePath,
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
