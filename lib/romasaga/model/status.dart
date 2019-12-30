class MyStatus {
  MyStatus(
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
    this.have,
    this.favorite,
  );

  factory MyStatus.empty(int id) {
    return MyStatus(id, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false);
  }

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
  bool have;
  bool favorite;

  int sumWithoutHp() {
    return str + vit + dex + agi + intelligence + spirit + love + attr;
  }

  MyStatusForEdit toEditModel() {
    return MyStatusForEdit(id, hp, str, vit, dex, agi, intelligence, spirit, love, attr, have, favorite);
  }
}

///
/// ステータス編集画面用のモデルクラス
///
class MyStatusForEdit {
  MyStatusForEdit(
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
    this.have,
    this.favorite,
  );

  int id;
  int hp;
  int str;
  int vit;
  int dex;
  int agi;
  int intelligence;
  int spirit;
  int love;
  int attr;
  bool have;
  bool favorite;

  bool isEmpty() {
    return (hp + str + vit + dex + agi + intelligence + spirit + love + attr) == 0;
  }

  void incrementHP() => hp++;

  void decrementHP() => (hp > 0) ? hp-- : hp = 0;

  void incrementStr() => str++;

  void decrementStr() => (str > 0) ? str-- : str = 0;

  void incrementVit() => vit++;

  void decrementVit() => (vit > 0) ? vit-- : vit = 0;

  void incrementDex() => dex++;

  void decrementDex() => (dex > 0) ? dex-- : dex = 0;

  void incrementAgi() => agi++;

  void decrementAgi() => (agi > 0) ? agi-- : agi = 0;

  void incrementInt() => intelligence++;

  void decrementInt() => (intelligence > 0) ? intelligence-- : intelligence = 0;

  void incrementSpirit() => spirit++;

  void decrementSpirit() => (spirit > 0) ? spirit-- : spirit = 0;

  void incrementLove() => love++;

  void decrementLove() => (love > 0) ? love-- : love = 0;

  void incrementAttr() => attr++;

  void decrementAttr() => (attr > 0) ? attr-- : attr = 0;

  MyStatus toMyStatus() {
    return MyStatus(id, hp, str, vit, dex, agi, intelligence, spirit, love, attr, have, favorite);
  }
}
