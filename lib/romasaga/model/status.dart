abstract class Status {
  const Status(
    this.id,
    this.hp,
    this.str,
    this.vit,
    this.dex,
    this.agi,
    this.intelligence,
    this.spirit,
    this.love,
    this.attr,
  );

  final int id;
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
    int id,
    int hp,
    int str,
    int vit,
    int dex,
    int agi,
    int intelligence,
    int spirit,
    int love,
    int attr,
    this.have,
    this.favorite,
  ) : super(id, hp, str, vit, dex, agi, intelligence, spirit, love, attr);

  MyStatus.empty(id)
      : this.have = false,
        this.favorite = false,
        super(id, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  bool have;
  bool favorite;
}

class StyleStatus extends Status {
  StyleStatus(
    int id,
    int str,
    int vit,
    int dex,
    int agi,
    int intelligence,
    int spirit,
    int love,
    int attr,
  ) : super(id, 0, str, vit, dex, agi, intelligence, spirit, love, attr);

  StyleStatus.empty(int id) : super(id, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}
