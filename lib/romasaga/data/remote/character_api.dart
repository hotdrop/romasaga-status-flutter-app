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

      return _parse(jsonObjects);
    } catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }

  List<Character> _parse(CharactersJsonObject obj) {
    final characters = <Character>[];

    for (var charObj in obj.characters) {
      final character = _jsonObjectToCharacter(charObj);
      characters.add(character);
    }
    return characters;
  }

  Character _jsonObjectToCharacter(CharacterJsonObject obj) {
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

  Style _jsonObjectToStyle(int characterId, StyleJsonObject obj) {
    RSLogger.d("キャラID=$characterId icon=${obj.iconFileName}");
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

  Future<String> findIconUrl(String iconFileName) async => await _rsService.getCharacterIconUrl(iconFileName);
}
