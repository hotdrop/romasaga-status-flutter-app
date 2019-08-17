import '../json/character_object.dart';
import '../../model/character.dart';

import '../..//service/romancing_service.dart';
import '../../common/saga_logger.dart';

class CharacterApi {
  static final CharacterApi _instance = CharacterApi._();
  CharacterApi._();

  factory CharacterApi() {
    return _instance;
  }

  RomancingService _romancingService = RomancingService();

  Future<List<Character>> findAll() async {
    try {
      String json = await _romancingService.readCharactersJson();
      final jsonObjects = CharactersJsonObject.parse(json);
      return CharactersJsonObject.toModel(jsonObjects);
    } catch (e) {
      SagaLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }
}
