import '../json/stage_object.dart';
import '../../model/stage.dart';

import '../../service/rs_service.dart';
import '../../common/rs_logger.dart';

class StageApi {
  StageApi(this._rsService);

  const StageApi._(this._rsService);

  factory StageApi.create() {
    return StageApi._(RSService.getInstance());
  }

  factory StageApi.test(RSService rsService) {
    return StageApi._(rsService);
  }

  final RSService _rsService;

  Future<List<Stage>> findAll() async {
    try {
      String json = await _rsService.readStagesJson();
      return StagesJsonObject.parse(json);
    } catch (e) {
      RSLogger.e('ステージデータの取得時にエラーが発生しました。', e);
      rethrow;
    }
  }
}
