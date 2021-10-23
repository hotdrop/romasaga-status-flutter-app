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

  void increment(StatusType type) {
    switch (type) {
      case StatusType.hp:
        hp++;
        break;
      case StatusType.str:
        str++;
        break;
      case StatusType.vit:
        vit++;
        break;
      case StatusType.dex:
        dex++;
        break;
      case StatusType.agi:
        agi++;
        break;
      case StatusType.intelligence:
        intelligence++;
        break;
      case StatusType.spirit:
        spirit++;
        break;
      case StatusType.love:
        love++;
        break;
      case StatusType.attr:
        attr++;
        break;
    }
  }

  void decrement(StatusType type) {
    switch (type) {
      case StatusType.hp:
        (hp > 0) ? hp-- : hp = 0;
        break;
      case StatusType.str:
        (str > 0) ? str-- : str = 0;
        break;
      case StatusType.vit:
        (vit > 0) ? vit-- : vit = 0;
        break;
      case StatusType.dex:
        (dex > 0) ? dex-- : dex = 0;
        break;
      case StatusType.agi:
        (agi > 0) ? agi-- : agi = 0;
        break;
      case StatusType.intelligence:
        (intelligence > 0) ? intelligence-- : intelligence = 0;
        break;
      case StatusType.spirit:
        (spirit > 0) ? spirit-- : spirit = 0;
        break;
      case StatusType.love:
        (love > 0) ? love-- : love = 0;
        break;
      case StatusType.attr:
        (attr > 0) ? attr-- : attr = 0;
        break;
    }
  }

  void update(StatusType type, int newVal) {
    switch (type) {
      case StatusType.hp:
        hp = newVal;
        break;
      case StatusType.str:
        str = newVal;
        break;
      case StatusType.vit:
        vit = newVal;
        break;
      case StatusType.dex:
        dex = newVal;
        break;
      case StatusType.agi:
        agi = newVal;
        break;
      case StatusType.intelligence:
        intelligence = newVal;
        break;
      case StatusType.spirit:
        spirit = newVal;
        break;
      case StatusType.love:
        love = newVal;
        break;
      case StatusType.attr:
        attr = newVal;
        break;
    }
  }

  bool isEmpty() {
    return (hp + str + vit + dex + agi + intelligence + spirit + love + attr) == 0;
  }

  MyStatus toMyStatus() {
    return MyStatus(id, hp, str, vit, dex, agi, intelligence, spirit, love, attr, have, favorite);
  }
}

enum StatusType { hp, str, vit, dex, agi, intelligence, spirit, love, attr }
