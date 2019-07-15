import 'weapon.dart';

class Character {
  final String name;
  final String title;
  final String production; // 登場作品
  final WeaponType weaponType;
  final String iconFileName;
  final List<Style> styles;

  Character(this.name, this.title, this.production, String weaponType, this.iconFileName)
      : this.weaponType = WeaponType(weaponType),
        this.styles = [];

  WeaponCategory get weaponCategory => weaponType.category;

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

  static const String rankSS = 'SS';
  static const String rankS = 'S';
  static const String rankA = 'A';

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
