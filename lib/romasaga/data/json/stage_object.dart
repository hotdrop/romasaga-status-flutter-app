import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../../model/stage.dart';

import '../../common/rs_logger.dart';

@JsonSerializable()
class StagesJsonObject {
  final List<StageJsonObject> stages;

  const StagesJsonObject({this.stages});

  factory StagesJsonObject.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      RSLogger.d("stage jsonがnullです。");
      return null;
    }
    return StagesJsonObject(
      stages: (json['stages'] as List)?.map((o) => StageJsonObject.fromJson(o as Map<String, dynamic>))?.toList(),
    );
  }

  static StagesJsonObject parse(String json) {
    final jsonMap = jsonDecode(json);
    final results = StagesJsonObject.fromJson(jsonMap);
    RSLogger.d('Stageをパースしました。 size=${results.stages.length}');
    return results;
  }

  static List<Stage> toModel(StagesJsonObject obj) {
    return obj.stages.map((o) => Stage(o.name, o.limit, o.order)).toList();
  }
}

@JsonSerializable()
class StageJsonObject {
  final String name;
  final int limit;
  final int order;

  const StageJsonObject(this.name, this.limit, this.order);

  StageJsonObject.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        limit = json['limit'] as int,
        order = json['order'] as int;
}
