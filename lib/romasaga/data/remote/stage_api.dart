import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'response/stage_json_object.dart';
import '../../model/stage.dart';
import '../../common/saga_logger.dart';

class StageApi {
  static final StageApi _instance = StageApi._();

  const StageApi._();
  factory StageApi() {
    return _instance;
  }

  Future<List<Stage>> findAll() async {
    try {
      return await rootBundle.loadStructuredData('res/json/stage.json', (String json) async {
        final jsonObjects = _parseJson(json);
        return _jsonObjectToModel(jsonObjects);
      });
    } on IOException catch (e) {
      SagaLogger.e('ステージデータの取得時にエラーが発生しました。', e);
      throw e;
    }
  }

  StagesJsonObject _parseJson(String json) {
    final jsonMap = jsonDecode(json);
    final results = StagesJsonObject.fromJson(jsonMap);
    SagaLogger.d("Stageをパースしました。 size=${results.stages.length}");
    return results;
  }

  List<Stage> _jsonObjectToModel(StagesJsonObject obj) {
    return obj.stages.map((o) => Stage(o.name, o.limit, o.order)).toList();
  }
}
