import '../json/character_object.dart';
import '../../model/character.dart';

import '../../common/romancing_service.dart';
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
      // TODO パスをgitで管理していないところから取得する。
      String json = await _romancingService.readJson(path: 'todo path');
      final jsonObjects = CharactersJsonObject.parse(json);
      return CharactersJsonObject.toModel(jsonObjects);
    } catch (e) {
      SagaLogger.e('キャラデータ取得時にエラーが発生しました。', e);
      throw e;
    }
  }
}
