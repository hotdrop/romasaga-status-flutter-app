class RSEnv {
  RSEnv._(this.characterJsonFileName, this.stageJsonFileName, this.lettersJsonFileName);

  factory RSEnv.dev() {
    res = RSEnv._('characters_dev.json', 'stage.json', 'letters_dev.json');
    return res;
  }

  factory RSEnv.prd() {
    res = RSEnv._('characters.json', 'stage.json', 'letters.json');
    return res;
  }

  static late RSEnv res;

  final String characterJsonFileName;
  final String stageJsonFileName;
  final String lettersJsonFileName;
}
