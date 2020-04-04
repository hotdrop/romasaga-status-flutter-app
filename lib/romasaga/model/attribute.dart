import 'package:rsapp/romasaga/common/rs_strings.dart';

class Attribute {
  Attribute(String name) {
    switch (name) {
      case RSStrings.attributeFire:
        _type = AttributeType.fire;
        return;
      case RSStrings.attributeCold:
        _type = AttributeType.cold;
        return;
      case RSStrings.attributeWind:
        _type = AttributeType.wind;
        return;
      case RSStrings.attributeSoil:
        _type = AttributeType.soil;
        return;
      case RSStrings.attributeThunder:
        _type = AttributeType.thunder;
        return;
      case RSStrings.attributeDark:
        _type = AttributeType.dark;
        return;
      case RSStrings.attributeShine:
        _type = AttributeType.shine;
        return;
      default:
        _type = AttributeType.none;
    }
  }

  AttributeType _type;
  AttributeType get type => _type;
}

enum AttributeType {
  none,
  fire,
  cold,
  wind,
  soil,
  thunder,
  dark,
  shine,
}
