import 'my_status.dart';

class Character {
  final String name;
  final String title;
  final String production; // 登場作品
  final WeaponType weaponType;
  final List<Style> styles;

  MyStatus _myStatus;

  Character(this.name, this.title, this.production, String weaponType, this._myStatus)
      : this.weaponType = WeaponType(weaponType),
        this.styles = [];

  String get weaponCategory => weaponType.category;
  int get nowHP => _myStatus.hp;
  int get nowStr => _myStatus.str;
  int get nowVit => _myStatus.vit;
  int get nowDex => _myStatus.dex;
  int get nowAgi => _myStatus.agi;
  int get nowInt => _myStatus.intelligence;
  int get nowSpi => _myStatus.spirit;
  int get nowLove => _myStatus.love;
  int get nowAttr => _myStatus.attr;

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
    _myStatus = status;
    // TODO DBに保存しに行く
  }

  Style getStyle(String rank) {
    return styles.where((style) => style.rank == rank).first;
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
