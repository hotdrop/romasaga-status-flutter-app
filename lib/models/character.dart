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

  ///
  /// 選択したスタイルをデフォルトスタイルに更新する
  ///
  Future<void> updateDefaultStyle({required int selectedCharacterId, required Style selectedStyle}) async {
    await ref.read(characterRepositoryProvider).saveSelectedRank(selectedCharacterId, selectedStyle.rank, selectedStyle.iconFilePath);
    _replace(
      newChara: state.where((e) => e.id == selectedCharacterId).first.copyWith(
            selectedStyleRank: selectedStyle.rank,
            selectedIconFilePath: selectedStyle.iconFilePath,
          ),
    );
  }

  ///
  /// サーバーから最新のアイコンパスを取得し画像データを更新する
  /// 画像はキャッシュしているのでこの処理が必要
  ///
  Future<void> refreshIcon({required int id, required Style selectedStyle}) async {
    final target = state.where((e) => e.id == id).first;
    final isAlreadySelected = (target.selectedStyleRank == selectedStyle.rank);
    await ref.read(characterRepositoryProvider).refreshIcon(selectedStyle, isAlreadySelected);

    final newStyles = await ref.read(characterRepositoryProvider).findStyles(target.id);
    _replace(newChara: target.copyWith(styles: newStyles));
  }

  ///
  /// ステータスの更新
  ///
  Future<void> updateMyStatus({required int id, required MyStatus newStatus}) async {
    await ref.read(myStatusRepositoryProvider).save(newStatus);
    _replace(
      newChara: state.where((e) => e.id == id).first.copyWith(myStatus: newStatus),
    );
  }

  ///
  /// イベント対象フラグの更新
  ///
  Future<void> saveStatusUpEvent({required int id, required bool statusUpEvent}) async {
    await ref.read(characterRepositoryProvider).saveStatusUpEvent(id, statusUpEvent);
    _replace(
      newChara: state.where((e) => e.id == id).first.copyWith(statusUpEvent: statusUpEvent),
    );
  }

  ///
  /// 高難易度フラグの更新
  ///
  Future<void> saveHighLevel({required int id, required bool useHighLevel}) async {
    await ref.read(characterRepositoryProvider).saveHighLevel(id, useHighLevel);
    _replace(
      newChara: state.where((e) => e.id == id).first.copyWith(highLevel: useHighLevel),
    );
  }

  ///
  /// お気に入りフラグの更新
  ///
  Future<void> saveFavorite({required int id, required bool favorite}) async {
    await ref.read(characterRepositoryProvider).saveFavorite(id, favorite);
    _replace(
      newChara: state.where((e) => e.id == id).first.copyWith(favorite: favorite),
    );
  }

  void _replace({required Character newChara}) {
    final idx = state.indexWhere((chara) => chara.id == newChara.id);
    state = List.of(state)..[idx] = newChara;
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

  factory Character.empty() {
    return Character(noneId, '', '', [], []);
  }

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

  static const int noneId = -1;

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
