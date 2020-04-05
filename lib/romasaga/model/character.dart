import 'package:rsapp/romasaga/model/attribute.dart';

import 'weapon.dart';
import 'status.dart';
import 'style.dart';

class Character {
  Character(
    this.id,
    this.name,
    this.production,
    this.weapon, {
    this.attributes,
    this.selectedStyleRank,
    this.selectedIconFilePath,
  }) : this.myStatus = MyStatus.empty(id);

  final int id;
  final String name;
  final String production; // 登場作品
  final Weapon weapon;
  final List<Attribute> attributes;

  String selectedStyleRank;
  String selectedIconFilePath;

  final styles = <Style>[];

  MyStatus myStatus;

  WeaponType get weaponType => weapon.type;
  WeaponCategory get weaponCategory => weapon.category;
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
