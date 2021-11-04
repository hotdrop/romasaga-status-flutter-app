import 'package:rsapp/common/rs_logger.dart';

class RSEnv {
  RSEnv._(this.characterJsonFileName, this.lettersJsonFileName);

  factory RSEnv.dev() {
    res = RSEnv._('characters_dev.json', 'letters_dev.json');
    RSLogger.d('デバッグ環境で実行します。');
    return res;
  }

  factory RSEnv.prd() {
    res = RSEnv._('characters.json', 'letters.json');
    RSLogger.d('プロダクト環境で実行します。');
    return res;
  }

  static late RSEnv res;

  final String characterJsonFileName;
  final String lettersJsonFileName;
}
