import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../../model/stage.dart';

import '../../common/rs_logger.dart';

@JsonSerializable()
class StagesJsonObject {
  const StagesJsonObject({this.stages});

  factory StagesJsonObject.fromJson(dynamic json) {
    if (json == null) {
      RSLogger.d("stage jsonがnullです。");
      return null;
    }
    return StagesJsonObject(
      stages: (json['stages'] as List)?.map((dynamic o) => StageJsonObject.fromJson(o as Map<String, dynamic>))?.toList(),
    );
  }

  final List<StageJsonObject> stages;

  static List<Stage> parse(String json) {
    final dynamic jsonMap = jsonDecode(json);
    final results = StagesJsonObject.fromJson(jsonMap);
    RSLogger.d('Stageをパースしました。 size=${results.stages.length}');

    return _toModel(results);
  }

  static List<Stage> _toModel(StagesJsonObject obj) {
    return obj.stages.map((o) => Stage(o.name, o.limit, o.order)).toList();
  }
}

@JsonSerializable()
class StageJsonObject {
  const StageJsonObject(this.name, this.limit, this.order);

  StageJsonObject.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        limit = json['limit'] as int,
        order = json['order'] as int;

  final String name;
  final int limit;
  final int order;
}
