import '../json/character_object.dart';
import '../../model/character.dart';

import '../../service/rs_service.dart';
import '../../common/rs_logger.dart';

class CharacterApi {
  const CharacterApi._(this._rsService);

  factory CharacterApi.create() {
    return CharacterApi._(RSService.getInstance());
  }

  final RSService _rsService;

  Future<List<Character>> findAll() async {
    try {
      String json = await _rsService.readCharactersJson();
      return CharactersJsonObject.parse(json);
    } catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      rethrow;
    }
  }

  Future<String> findIconUrl(String iconFileName) async => await _rsService.getCharacterIconUrl(iconFileName);
}
