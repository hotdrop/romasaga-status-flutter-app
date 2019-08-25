import '../json/character_object.dart';
import '../../model/character.dart';

import '../..//service/rs_service.dart';
import '../../common/rs_logger.dart';

class CharacterApi {
  final RSService _romancingService;
  CharacterApi({RSService rsService}) : _romancingService = (rsService == null) ? RSService() : rsService;

  Future<List<Character>> findAll() async {
    try {
      String json = await _romancingService.readCharactersJson();
      final jsonObjects = CharactersJsonObject.parse(json);
      return CharactersJsonObject.toModel(jsonObjects);
    } catch (e) {
      RSLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }
}
