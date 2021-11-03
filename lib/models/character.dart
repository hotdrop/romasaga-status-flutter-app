import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:collection/collection.dart';

class Character {
  Character(
    this.id,
    this.name,
    this.production,
    this.weapon,
    this.attributes, {
    this.selectedStyleRank,
    this.selectedIconFilePath,
    this.statusUpEvent = false,
    this.myStatus,
  });

  final int id;
  final String name;
  final String production; // 登場作品
  final Weapon weapon;
  final List<Attribute>? attributes;
  String? selectedStyleRank;
  String? selectedIconFilePath;
  bool statusUpEvent;
  MyStatus? myStatus;

  // スタイル情報は後から追加するので別出ししている。
  final styles = <Style>[];

  WeaponType get weaponType => weapon.type;

  WeaponCategory get weaponCategory => weapon.category;

  Style? get selectedStyle => styles.firstWhereOrNull((style) => style.rank == selectedStyleRank);

  void addStyle(Style style) {
    styles.add(style);
  }

  void addAllStyle(List<Style> argStyles) {
    styles.addAll(argStyles);
  }

  void refreshStyles(List<Style> argStyles) {
    styles.clear();
    styles.addAll(argStyles);
  }

  Style getStyle(String rank) {
    return styles.firstWhere((style) => style.rank == rank);
  }

  String getShowIconPath() {
    return selectedIconFilePath ?? styles.first.iconFilePath;
  }

  Character withStatus(MyStatus status) {
    final newCharacter = Character(
      id,
      name,
      production,
      weapon,
      attributes,
      selectedStyleRank: selectedStyleRank,
      selectedIconFilePath: selectedIconFilePath,
      statusUpEvent: statusUpEvent,
      myStatus: status,
    );
    newCharacter.addAllStyle(styles);
    return newCharacter;
  }
}
