class MyStatus {
  MyStatus(
    this.id,
    this.hp,
    this.str,
    this.vit,
    this.dex,
    this.agi,
    this.inte,
    this.spi,
    this.love,
    this.attr,
    this.favorite,
    this.useHighLevel,
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
  final int inte;
  final int spi;
  final int love;
  final int attr;
  bool favorite;
  bool useHighLevel;

  int sumWithoutHp() {
    return str + vit + dex + agi + inte + spi + love + attr;
  }
}

enum StatusType { hp, str, vit, dex, agi, inte, spirit, love, attr }
