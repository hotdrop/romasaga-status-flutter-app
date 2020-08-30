import 'package:rsapp/romasaga/model/attribute.dart';
import 'package:rsapp/romasaga/model/status.dart';
import 'package:rsapp/romasaga/model/style.dart';
import 'package:rsapp/romasaga/model/weapon.dart';

class Character {
  Character(
    this.id,
    this.name,
    this.production,
    this.weapon, {
    this.attributes,
    this.selectedStyleRank,
    this.selectedIconFilePath,
    this.statusUpEvent = false,
  }) : this.myStatus = MyStatus.empty(id);

  final int id;
  final String name;
  final String production; // 登場作品
  final Weapon weapon;
  final List<Attribute> attributes;

  String selectedStyleRank;
  String selectedIconFilePath;
  bool statusUpEvent;

  final styles = <Style>[];

  MyStatus myStatus;

  WeaponType get weaponType => weapon.type;

  WeaponCategory get weaponCategory => weapon.category;

  Style get selectedStyle => getStyle(selectedStyleRank);

  void addStyles(List<Style> argStyles) {
    styles.addAll(argStyles);
  }

  void addStyle(Style style) {
    styles.add(style);
  }

  void refreshStyles(List<Style> argStyles) {
    styles.clear();
    styles.addAll(argStyles);
  }

  Style getStyle(String rank) {
    return styles.firstWhere((style) => style.rank == rank);
  }
}
