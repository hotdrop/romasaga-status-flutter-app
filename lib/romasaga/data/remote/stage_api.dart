import '../json/stage_object.dart';
import '../../model/stage.dart';

import '../../service/rs_service.dart';
import '../../common/rs_logger.dart';

class StageApi {
  StageApi({RSService rsService}) : _romancingService = (rsService == null) ? RSService() : rsService;

  final RSService _romancingService;

  Future<List<Stage>> findAll() async {
    try {
      String json = await _romancingService.readStagesJson();
      return StagesJsonObject.parse(json);
    } catch (e) {
      RSLogger.e('ステージデータの取得時にエラーが発生しました。', e);
      rethrow;
    }
  }
}
