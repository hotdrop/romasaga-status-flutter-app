import '../json/stage_object.dart';
import '../../model/stage.dart';

import '../../service/rs_service.dart';
import '../../common/rs_logger.dart';

class StageApi {
  final RSService _romancingService;
  StageApi({RSService rsService}) : _romancingService = (rsService == null) ? RSService() : rsService;

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
