import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/res/rs_strings.dart';

class Attribute {
  Attribute({String name, int type}) {
    if (name != null) {
      _type = _convert(name);
    }
    if (type != null) {
      _type = AttributeType.values.firstWhere((v) => v.index == type, orElse: () => null);
    }
    if (_type == null) {
      RSLogger.d('typeがnullです');
      throw FormatException('typeがnullです');
    }
  }

  AttributeType _type;
  AttributeType get type => _type;

  AttributeType _convert(String name) {
    switch (name) {
      case RSStrings.attributeFire:
        return AttributeType.fire;
      case RSStrings.attributeCold:
        return AttributeType.cold;
      case RSStrings.attributeWind:
        return AttributeType.wind;
      case RSStrings.attributeSoil:
        return AttributeType.soil;
      case RSStrings.attributeThunder:
        return AttributeType.thunder;
      case RSStrings.attributeDark:
        return AttributeType.dark;
      case RSStrings.attributeShine:
        return AttributeType.shine;
      default:
        throw FormatException('属性名が誤っています。（火、水, 風, 土, 雷, 闇, 光のいずれか） name=$name');
    }
  }
}

enum AttributeType {
  fire,
  cold,
  wind,
  soil,
  thunder,
  dark,
  shine,
}
