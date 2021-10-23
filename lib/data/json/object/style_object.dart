import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/data/json/converter/style_object_converter.dart';

part 'style_object.freezed.dart';
part 'style_object.g.dart';

///
/// キャラクタースタイルのJsonオブジェクト
///
@freezed
class StyleObject with _$StyleObject {
  factory StyleObject({
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
  }) = _StyleObject;

  factory StyleObject.fromJson(Map<String, dynamic> json) => converter.fromJson(json);

  static const converter = StyleObjectConverter();
}
