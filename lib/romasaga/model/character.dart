import 'weapon.dart';
import 'status.dart';
import 'style.dart';

class Character {
  Character(
    this.id,
    this.name,
    this.production,
    String weaponType, {
    this.selectedStyleRank,
    this.selectedIconFilePath,
  })  : this.weaponType = WeaponType(weaponType),
        this.myStatus = MyStatus.empty(id);

  final int id;
  final String name;
  final String production; // 登場作品
  final WeaponType weaponType;

  String selectedStyleRank;
  String selectedIconFilePath;

  final styles = <Style>[];

  MyStatus myStatus;

  WeaponCategory get weaponCategory => weaponType.category;
  Style get selectedStyle => getStyle(selectedStyleRank);

  void addStyles(List<Style> styles) {
    for (var style in styles) {
      addStyle(style);
    }
  }

  void addStyle(Style style) {
    styles.add(style);
  }

  Style getStyle(String rank) {
    return styles.firstWhere((style) => style.rank == rank);
  }
}
