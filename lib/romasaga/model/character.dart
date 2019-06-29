class Character {
  final String name;
  final String title;

  final String production;
  WeaponType weaponType;

  final styles = List<Style>();

  MyStatus _currentStatus;

  Character(this.name, this.title, this.production, argWeaponType) {
    weaponType = WeaponType(argWeaponType);
    // TODO これテスト
    _currentStatus = MyStatus(720, 45, 47, 56, 55, 57, 45, 51, 45);
  }

  String get weaponCategory => weaponType.category;
  int get nowHP => (_currentStatus != null) ? _currentStatus.hp : 0;
  int get nowStr => (_currentStatus != null) ? _currentStatus.str : 0;
  int get nowVit => (_currentStatus != null) ? _currentStatus.vit : 0;
  int get nowDex => (_currentStatus != null) ? _currentStatus.dex : 0;
  int get nowAgi => (_currentStatus != null) ? _currentStatus.agi : 0;
  int get nowInt => (_currentStatus != null) ? _currentStatus.intelligence : 0;
  int get nowSpi => (_currentStatus != null) ? _currentStatus.spirit : 0;
  int get nowLove => (_currentStatus != null) ? _currentStatus.love : 0;
  int get nowAttr => (_currentStatus != null) ? _currentStatus.attr : 0;

  List<String> getStyleRanks({bool distinct = false}) {
    if (distinct) {
      final ranks = _getNormalRanks();
      return _distinct(ranks).toList()..sort((s, t) => s.compareTo(t));
    } else {
      return styles.map((style) => style.rank).toList()..sort((s, t) => s.compareTo(t));
    }
  }

  void addStyle(String rank, int str, int vit, int dex, int agi, int intelligence, int spi, int love, int attr) {
    final style = Style(rank, str, vit, dex, agi, intelligence, spi, love, attr);
    styles.add(style);
  }

  void saveMyStatus(MyStatus status) {
    _currentStatus = status;
  }

  List<String> _getNormalRanks() {
    final ranks = <String>[];
    styles.forEach((style) {
      if (style.rank.contains(Style.rankSS)) {
        ranks.add(Style.rankSS);
      } else if (style.rank.contains(Style.rankS)) {
        ranks.add(Style.rankS);
      } else {
        ranks.add(Style.rankA);
      }
    });
    return ranks;
  }

  Iterable<String> _distinct(List<String> lst) {
    Set<String> s = Set();
    return lst.where((e) => s.add(e));
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

  static int rankSort(String first, String second) {
    final firstPriority = (first == rankA) ? 1 : (first == rankS) ? 2 : 3;
    final secondPriority = (second == rankA) ? 1 : (second == rankS) ? 2 : 3;
    if (firstPriority < secondPriority) {
      return -1;
    } else if (firstPriority == secondPriority) {
      return 0;
    } else {
      return 1;
    }
  }
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
}
