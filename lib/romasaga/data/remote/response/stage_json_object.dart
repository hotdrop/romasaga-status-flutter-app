import 'package:json_annotation/json_annotation.dart';

import '../../../common/saga_logger.dart';

@JsonSerializable()
class StagesJsonObject {
  final List<StageJsonObject> stages;

  const StagesJsonObject({this.stages});

  factory StagesJsonObject.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      SagaLogger.d("stage jsonがnullです。");
      return null;
    }
    return StagesJsonObject(
      stages: (json['stages'] as List)?.map((o) => StageJsonObject.fromJson(o as Map<String, dynamic>))?.toList(),
    );
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
