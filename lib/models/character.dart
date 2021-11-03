import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:collection/collection.dart';

final characterNotifierProvider = StateNotifierProvider<_CharacterNotifier, List<Character>>((ref) {
  return _CharacterNotifier(ref.read);
});

class _CharacterNotifier extends StateNotifier<List<Character>> {
  _CharacterNotifier(this._read) : super(<Character>[]);

  final Reader _read;

  Future<void> refresh() async {
    final characters = await _read(characterRepositoryProvider).findAll();
    final myStatuses = await _read(myStatusRepositoryProvider).findAll();
    state = await _merge(characters, myStatuses);
  }

  Future<List<Character>> _merge(List<Character> characters, List<MyStatus> statues) async {
    if (statues.isNotEmpty) {
      RSLogger.d('登録ステータス${statues.length}件をキャラ情報にマージします。');
      List<Character> newCharacters = [];
      for (var c in characters) {
        final status = statues.firstWhereOrNull((s) => s.id == c.id);
        if (status != null) {
          newCharacters.add(c.withStatus(status));
        } else {
          newCharacters.add(c);
        }
      }
      return newCharacters;
    } else {
      return characters;
    }
  }
}

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
