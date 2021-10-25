import 'package:freezed_annotation/freezed_annotation.dart';

part 'letter_response.freezed.dart';
part 'letter_response.g.dart';

@freezed
class LetterResponse with _$LetterResponse {
  factory LetterResponse({
    @JsonKey(name: 'year') required int year,
    @JsonKey(name: 'month') required int month,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'short_title') required String shortTitle,
    @JsonKey(name: 'image_name') required String imageName,
  }) = _LetterResponse;

  factory LetterResponse.fromJson(Map<String, Object?> json) => _$LetterResponseFromJson(json);
}
