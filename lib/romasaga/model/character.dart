import 'weapon.dart';
import 'status.dart';
import 'style.dart';

class Character {
  final int id;
  final String name;
  final String production; // 登場作品
  final WeaponType weaponType;

  String selectedStyleRank;
  String selectedIconFilePath;

  final styles = <Style>[];

  MyStatus myStatus;

  Character(
    this.id,
    this.name,
    this.production,
    String weaponType, {
    this.selectedStyleRank,
    this.selectedIconFilePath,
  })  : this.weaponType = WeaponType(weaponType),
        this.myStatus = MyStatus.empty(id);

  WeaponCategory get weaponCategory => weaponType.category;

  void addStyles(List<Style> styles) {
    for (var style in styles) {
      addStyle(style);
    }
  }

  void addStyle(Style style) {
    styles.add(style);
  }

  Style getSelectedStyle() {
    return getStyle(selectedStyleRank);
  }

  Style getStyle(String rank) {
    return styles.firstWhere((style) => style.rank == rank);
  }

  int getTotalStatus() {
    return myStatus.sumWithoutHp();
  }
}
