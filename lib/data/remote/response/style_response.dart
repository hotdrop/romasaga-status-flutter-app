import 'package:freezed_annotation/freezed_annotation.dart';

part 'style_response.freezed.dart';
part 'style_response.g.dart';

@freezed
class StyleResponse with _$StyleResponse {
  factory StyleResponse({
    @JsonKey(name: 'rank') required String rank,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'str') required int str,
    @JsonKey(name: 'vit') required int vit,
    @JsonKey(name: 'dex') required int dex,
    @JsonKey(name: 'agi') required int agi,
    @JsonKey(name: 'int') required int intelligence,
    @JsonKey(name: 'spi') required int spi,
    @JsonKey(name: 'love') required int love,
    @JsonKey(name: 'attr') required int attr,
    @JsonKey(name: 'icon') required String iconFileName,
  }) = _StyleResponse;

  factory StyleResponse.fromJson(Map<String, Object?> json) => _$StyleResponseFromJson(json);
}
