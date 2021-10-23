import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/data/json/object/style_object.dart';

///
/// このConverterは作りたくなかった。。
/// jsonでは知力をintで表現しているがDartではintは予約後なのでintelligenceにしている。
/// そのためわざわざこのコンバーターを用意した。
///
class StyleObjectConverter implements JsonConverter<StyleObject, Map<String, dynamic>> {
  const StyleObjectConverter();

  @override
  StyleObject fromJson(Map<String, dynamic> json) {
    return StyleObject(
      rank: json['rank'] as String,
      title: json['title'] as String,
      str: json['str'] as int,
      vit: json['vit'] as int,
      dex: json['dex'] as int,
      agi: json['agi'] as int,
      intelligence: json['int'] as int,
      spi: json['spi'] as int,
      love: json['love'] as int,
      attr: json['attr'] as int,
      iconFileName: json['icon'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(StyleObject obj) => obj.toJson();
}
