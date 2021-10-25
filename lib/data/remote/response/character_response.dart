import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/data/remote/response/style_response.dart';

part 'character_response.freezed.dart';
part 'character_response.g.dart';

@freezed
class CharacterResponse with _$CharacterResponse {
  factory CharacterResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'weapon_type') required String weaponTypeName,
    @JsonKey(name: 'attributes') List<String>? attributeNames,
    @JsonKey(name: 'production') required String production,
    @JsonKey(name: 'styles') required List<StyleResponse> styles,
  }) = _CharacterResponse;

  factory CharacterResponse.fromJson(Map<String, Object?> json) => _$CharacterResponseFromJson(json);
}
