import '../json/character_object.dart';
import '../../service/rs_service.dart';
import '../../model/character.dart';
import '../../common/rs_logger.dart';

class CharacterApi {
  CharacterApi({RSService rsService}) : _rsService = (rsService == null) ? RSService() : rsService;

  final RSService _rsService;

  Future<List<Character>> findAll() async {
    try {
      String json = await _rsService.readCharactersJson();
      return CharactersJsonObject.parse(json);
    } catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }

  Future<String> findIconUrl(String iconFileName) async => await _rsService.getCharacterIconUrl(iconFileName);
}
