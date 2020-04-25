import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:rsapp/romasaga/model/stage.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

@JsonSerializable()
class StagesJsonObject {
  const StagesJsonObject._(this._stages);

  factory StagesJsonObject._fromJson(dynamic json) {
    if (json == null) {
      RSLogger.d("stage jsonがnullです。");
      return null;
    }
    return StagesJsonObject._(
      (json['stages'] as List)?.map((dynamic o) => StageJsonObject.fromJson(o as Map<String, dynamic>))?.toList(),
    );
  }

  final List<StageJsonObject> _stages;

  static List<Stage> parseToObjects(String json) {
    final dynamic jsonMap = jsonDecode(json);
    final results = StagesJsonObject._fromJson(jsonMap);
    RSLogger.d('Stageをパースしました。 size=${results._stages.length}');

    return results._stages.map((o) => Stage(o.name, o.limit, o.order)).toList();
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
