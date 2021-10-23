import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage_object.freezed.dart';
part 'stage_object.g.dart';

///
///　TODO これいらない
@freezed
class StageObject with _$StageObject {
  factory StageObject({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'limit') required int limit,
    @JsonKey(name: 'order') required int order,
  }) = _StageObject;

  factory StageObject.fromJson(Map<String, dynamic> json) => _$StageObjectFromJson(json);
}
