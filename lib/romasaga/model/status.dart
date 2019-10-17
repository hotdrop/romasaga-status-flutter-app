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

  MyStatus.empty(int id)
      : this.have = false,
        this.favorite = false,
        super(id, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  bool have;
  bool favorite;

  int sumWithoutHp() {
    return str + vit + dex + agi + intelligence + spirit + love + attr;
  }
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
