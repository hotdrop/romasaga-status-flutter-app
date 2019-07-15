abstract class Status {
  const Status(this.charName, this.hp, this.str, this.vit, this.dex, this.agi, this.intelligence, this.spirit, this.love, this.attr);

  final String charName;
  final int hp;
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int intelligence;
  final int spirit;
  final int love;
  final int attr;

  static const String hpName = 'HP';
  static const String strName = '腕力';
  static const String vitName = '体力';
  static const String dexName = '器用';
  static const String agiName = '素早';
  static const String intName = '知力';
  static const String spiName = '精神';
  static const String loveName = ' 愛 ';
  static const String attrName = '魅力';
}

class MyStatus extends Status {
  MyStatus(
    String charName,
    int hp,
    int str,
    int vit,
    int dex,
    int agi,
    int intelligence,
    int spirit,
    int love,
    int attr,
  ) : super(charName, hp, str, vit, dex, agi, intelligence, spirit, love, attr);

  MyStatus.empty(charName) : super(charName, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

class StyleStatus extends Status {
  StyleStatus(
    int str,
    int vit,
    int dex,
    int agi,
    int intelligence,
    int spirit,
    int love,
    int attr,
  ) : super('', 0, str, vit, dex, agi, intelligence, spirit, love, attr);

  StyleStatus.empty() : super('', 0, 0, 0, 0, 0, 0, 0, 0, 0);
}
