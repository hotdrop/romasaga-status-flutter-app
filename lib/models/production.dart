import 'package:rsapp/res/rs_strings.dart';

///
/// 作品のモデルクラス
///
class Production {
  static bool equal(ProductionType type, String name) {
    final nameToType = convert(name);
    return type == nameToType;
  }

  static ProductionType convert(String name) {
    switch (name) {
      case RSStrings.productRomaSaga1:
        return ProductionType.romasaga1;
      case RSStrings.productRomaSaga2:
        return ProductionType.romasaga2;
      case RSStrings.productRomaSaga3:
        return ProductionType.romasaga3;
      case RSStrings.productSagaFro1:
        return ProductionType.sagafro1;
      case RSStrings.productSagaFro2:
        return ProductionType.sagafro2;
      case RSStrings.productSagaSca:
        return ProductionType.sagasca;
      case RSStrings.productUnLimited:
        return ProductionType.unlimited;
      case RSStrings.productEmperorsSaga:
        return ProductionType.emperorssaga;
      case RSStrings.productRomaSagaRS:
        return ProductionType.romasagaRS;
      case RSStrings.productSaga:
        return ProductionType.saga1;
      case RSStrings.productSaga2:
        return ProductionType.saga2;
      default:
        throw FormatException('不正なProductionNameです。name=$name');
    }
  }
}

enum ProductionType {
  romasaga1,
  romasaga2,
  romasaga3,
  sagafro1,
  sagafro2,
  sagasca,
  unlimited,
  emperorssaga,
  romasagaRS,
  saga1,
  saga2,
}
