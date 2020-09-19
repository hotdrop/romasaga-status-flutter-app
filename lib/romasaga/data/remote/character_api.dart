import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/json/character_object.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/service/rs_service.dart';

class CharacterApi {
  const CharacterApi._(this._rsService);

  factory CharacterApi.create() {
    return CharacterApi._(RSService.getInstance());
  }

  final RSService _rsService;

  Future<List<Character>> findAll() async {
    try {
      String json = await _rsService.readCharactersJson();
      return CharactersJsonObject.parseToObjects(json);
    } catch (e, s) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e, s);
      rethrow;
    }
  }

  Future<String> findIconUrl(String iconFileName) async => await _rsService.getCharacterIconUrl(iconFileName);
}
