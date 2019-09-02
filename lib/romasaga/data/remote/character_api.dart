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
      return await _parseToModelList(jsonObjects);
    } catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }

  Future<List<Character>> _parseToModelList(CharactersJsonObject obj) async {
    final characters = <Character>[];

    for (var charObj in obj.characters) {
      final character = Character(charObj.id, charObj.name, charObj.production, charObj.weaponType);

      for (var styleObj in charObj.styles) {
        final style = await jsonObjectToStyleModel(character.id, styleObj);
        character.addStyle(style);

        if (character.selectedStyleRank == null) {
          character.selectedStyleRank = style.rank;
          character.selectedIconFilePath = style.iconFilePath;
        }
      }

      characters.add(character);
    }
    return characters;
  }

  Future<Style> jsonObjectToStyleModel(int characterId, StyleJsonObject obj) async {
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
