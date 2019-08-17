import '../json/stage_object.dart';
import '../../model/stage.dart';

import 'package:rsapp/romasaga/service/romancing_service.dart';
import '../../common/saga_logger.dart';

class StageApi {
  final String storagePath = 'stage.json';

  static final StageApi _instance = StageApi._();
  StageApi._();

  factory StageApi() {
    return _instance;
  }

  RomancingService _romancingService = RomancingService();

  Future<List<Stage>> findAll() async {
    try {
      String json = await _romancingService.readJson(path: storagePath);
      final jsonObjects = StagesJsonObject.parse(json);
      return StagesJsonObject.toModel(jsonObjects);
    } catch (e) {
      SagaLogger.e('ステージデータの取得時にエラーが発生しました。', e);
      throw e;
    }
  }
}
