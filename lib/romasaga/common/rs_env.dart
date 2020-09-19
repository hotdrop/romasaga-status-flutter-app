class RSEnv {
  RSEnv._(this.characterJsonFileName, this.stageJsonFileName, this.lettersJsonFileName);

  factory RSEnv.dev() {
    instance = RSEnv._('characters_dev.json', 'stage.json', 'letters.json');
    return instance;
  }

  factory RSEnv.prd() {
    instance = RSEnv._('characters.json', 'stage.json', 'letters.json');
    return instance;
  }

  static RSEnv instance;

  final String characterJsonFileName;
  final String stageJsonFileName;
  final String lettersJsonFileName;
}
