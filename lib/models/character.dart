import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:collection/collection.dart';

// キャラクターデータは全てこのProviderを参照、更新する
final characterProvider = NotifierProvider<CharacterNotifier, List<Character>>(CharacterNotifier.new);

class CharacterNotifier extends Notifier<List<Character>> {
  @override
  List<Character> build() {
    return [];
  }

  ///
  /// アプリ起動時、最初の1度だけ実行する
  ///
  Future<void> init() async {
    final characters = await ref.read(characterRepositoryProvider).findAll();
    final myStatuses = await ref.read(myStatusRepositoryProvider).findAll();
    state = await _merge(characters, myStatuses);
  }

  Future<List<Character>> _merge(List<Character> characters, List<MyStatus> statues) async {
    if (statues.isNotEmpty) {
      RSLogger.d('登録ステータス${statues.length}件をキャラ情報にマージします。');
      List<Character> newCharacters = [];
      for (var c in characters) {
        final status = statues.firstWhereOrNull((s) => s.id == c.id);
        if (status != null) {
          newCharacters.add(c.copyWith(myStatus: status));
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
    this.weapons,
    this.attributes, {
    this.selectedStyleRank,
    this.selectedIconFilePath,
    this.statusUpEvent = false,
    this.myStatus,
  });

  final int id;
  final String name;
  final String production; // 登場作品
  final List<Weapon> weapons;
  final List<Attribute>? attributes;
  String? selectedStyleRank;
  String? selectedIconFilePath;
  bool statusUpEvent;
  MyStatus? myStatus;

  // スタイル情報は後から追加するので別出ししている。
  final styles = <Style>[];

  List<WeaponType> get weaponTypes => weapons.map((e) => e.type).toList();

  List<WeaponCategory> get weaponCategories => weapons.map((e) => e.category).toList();

  List<String> get allRank => styles.map((style) => style.rank).toList()..sort((s, t) => s.compareTo(t));

  bool get favorite => myStatus?.favorite ?? false;
  bool get useHighLevel => myStatus?.useHighLevel ?? false;

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
      weapons,
      attributes,
      selectedStyleRank: selectedStyleRank,
      selectedIconFilePath: selectedIconFilePath,
      statusUpEvent: statusUpEvent,
      myStatus: status,
    );
    newCharacter.addAllStyle(styles);
    return newCharacter;
  }

  Character copyWith({
    String? selectedStyleRank,
    String? selectedIconFilePath,
    MyStatus? myStatus,
    List<Style>? styles,
    bool? favorite,
    bool? statusUpEvent,
    bool? highLevel,
  }) {
    final newStatus = myStatus ?? this.myStatus ?? MyStatus.empty(id);
    if (favorite != null) {
      newStatus.favorite = favorite;
    }
    if (highLevel != null) {
      newStatus.useHighLevel = highLevel;
    }

    final newCharacter = Character(
      id,
      name,
      production,
      weapons,
      attributes,
      selectedStyleRank: selectedStyleRank ?? this.selectedStyleRank,
      selectedIconFilePath: selectedIconFilePath ?? this.selectedIconFilePath,
      statusUpEvent: statusUpEvent ?? this.statusUpEvent,
      myStatus: newStatus,
    );

    newCharacter.addAllStyle(styles ?? this.styles);

    return newCharacter;
  }
}
