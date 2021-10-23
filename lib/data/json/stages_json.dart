import 'dart:convert';

import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/json/object/stage_object.dart';
import 'package:rsapp/models/stage.dart';

class StagesJson {
  static List<Stage> parse(String json) {
    final dynamic jsonMap = jsonDecode(json);
    final results = (jsonMap['stages'] as List) //
        .map((dynamic o) => StageObject.fromJson(o as Map<String, dynamic>))
        .toList();
    RSLogger.d('Stageをパースしました。 size=${results.length}');

    return results.map((obj) => Stage(obj.name, obj.limit, obj.order)).toList();
  }
}
