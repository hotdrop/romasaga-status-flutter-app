import 'package:rsapp/common/rs_logger.dart';

class RSEnv {
  RSEnv._(this.characterJsonFileName);

  factory RSEnv.dev() {
    res = RSEnv._('characters_dev.json');
    RSLogger.d('デバッグ環境で実行します。');
    return res;
  }

  factory RSEnv.prd() {
    res = RSEnv._('characters.json');
    RSLogger.d('プロダクト環境で実行します。');
    return res;
  }

  static late RSEnv res;

  final String characterJsonFileName;
}
