import '../json/stage_object.dart';
import '../../model/stage.dart';

import '../../service/rs_service.dart';
import '../../common/rs_logger.dart';

class StageApi {
  static final StageApi _instance = StageApi._();
  StageApi._();

  factory StageApi() {
    return _instance;
  }

  RSService _romancingService = RSService();

  Future<List<Stage>> findAll() async {
    try {
      String json = await _romancingService.readStagesJson();
      final jsonObjects = StagesJsonObject.parse(json);
      return StagesJsonObject.toModel(jsonObjects);
    } catch (e) {
      RSLogger.e('ステージデータの取得時にエラーが発生しました。', e);
      throw e;
    }
  }
}
