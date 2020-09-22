import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/romasaga/data/json/converter/StyleObjectConverter.dart';

part 'style_object.freezed.dart';

part 'style_object.g.dart';

///
/// キャラクタースタイルのJsonオブジェクト
///
@freezed
abstract class StyleObject with _$StyleObject {
  const factory StyleObject({
    @required String rank,
    @required String title,
    @required int str,
    @required int vit,
    @required int dex,
    @required int agi,
    @required int intelligence,
    @required int spi,
    @required int love,
    @required int attr,
    @required String iconFileName,
  }) = _StyleObject;

  factory StyleObject.fromJson(Map<String, dynamic> json) => converter.fromJson(json);

  static const converter = StyleObjectConverter();
}
