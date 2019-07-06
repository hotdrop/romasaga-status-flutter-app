class MyStatus {
  final int hp;
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int intelligence;
  final int spirit;
  final int love;
  final int attr;

  const MyStatus(this.hp, this.str, this.vit, this.dex, this.agi, this.intelligence, this.spirit, this.love, this.attr);
  const MyStatus.empty()
      : this.hp = 0,
        this.str = 0,
        this.vit = 0,
        this.dex = 0,
        this.agi = 0,
        this.intelligence = 0,
        this.spirit = 0,
        this.love = 0,
        this.attr = 0;
}
