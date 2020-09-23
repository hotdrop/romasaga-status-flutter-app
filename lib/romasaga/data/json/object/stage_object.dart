import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage_object.freezed.dart';

part 'stage_object.g.dart';

@freezed
abstract class StageObject with _$StageObject {
  const factory StageObject({
    @required String name,
    @required int limit,
    @required int order,
  }) = _StageObject;

  factory StageObject.fromJson(Map<String, dynamic> json) => _$StageObjectFromJson(json);
}
