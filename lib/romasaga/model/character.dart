class Character {
  final String name;
  final String title;

  final String production;
  WeaponType weaponType;

  final styles = List<Style>();

  Character(this.name, this.title, this.production, argWeaponType) {
    weaponType = WeaponType(argWeaponType);
  }

  String get weaponCategory => weaponType.category;

  List<String> get styleRanks => styles.map((style) => style.rank).toList();

  void addStyle(String rank, int str, int vit, int dex, int agi, int intelligence, int spi, int love, int attr) {
    final style = Style(rank, str, vit, dex, agi, intelligence, spi, love, attr);
    styles.add(style);
  }
}

class Style {
  final String rank;
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int intelligence;
  final int spirit;
  final int love;
  final int attr;

  const Style(this.rank, this.str, this.vit, this.dex, this.agi, this.intelligence, this.spirit, this.love, this.attr);

  static const String rankSS = "SS";
  static const String rankS = "S";
  static const String rankA = "A";
}

class WeaponType {
  final String name;
  String get category {
    switch (name) {
      case sword:
      case largeSword:
      case axe:
        return "斬";
      case hummer:
      case knuckle:
      case gun:
        return "打";
      case rapier:
      case spear:
      case bow:
        return "突";
      case rod:
        return "術";
      default:
        return "不明";
    }
  }

  static const String sword = "剣";
  static const String largeSword = "大剣";
  static const String axe = "斧";

  static const String hummer = "棍棒";
  static const String knuckle = "体術";
  static const String gun = "銃";

  static const String rapier = "小剣";
  static const String spear = "槍";
  static const String bow = "弓";

  static const String rod = "杖";

  WeaponType(this.name);
}
