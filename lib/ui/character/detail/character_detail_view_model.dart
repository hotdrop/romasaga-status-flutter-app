import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:collection/collection.dart';

part 'character_detail_view_model.g.dart';

@riverpod
class CharacterDetailViewModel extends _$CharacterDetailViewModel {
  @override
  Future<void> build(Character character) async {
    final stage = await ref.read(stageRepositoryProvider).find();
    ref.read(_uiStateProvider.notifier).state = _UiState.create(character: character, stage: stage);
  }
}

final characterDetailMethodsProvider = Provider((ref) => _CharacterDetailMethods(ref));

class _CharacterDetailMethods {
  const _CharacterDetailMethods(this.ref);

  final Ref ref;

  // キャラ情報
  int get id => ref.read(_uiStateProvider).character.id;
  List<String> get allRank => ref.read(_uiStateProvider).character.allRank;
  String get production => ref.read(_uiStateProvider).character.production;
  String get name => ref.read(_uiStateProvider).character.name;
  List<Weapon> get weapons => ref.read(_uiStateProvider).character.weapons;
  List<Attribute>? get attributes => ref.read(_uiStateProvider).character.attributes;

  // ステージ情報
  String get stageName => ref.read(_uiStateProvider).stage.name;
  int get hpLimit => ref.read(_uiStateProvider).stage.hpLimit;
  int get statusLimit => ref.read(_uiStateProvider).stage.statusLimit;

  void onSelectRank(String rank) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(selectedStyleRank: rank));
  }

  ///
  /// 自身のステータスを再取得する
  ///
  // Future<void> refreshMyStatus() async {
  // await ref.read(_uiStateProvider.notifier).updateMyStatus(_character.id);
  // ref.read(characterDetailIsUpdateStatus.notifier).state = true;
  /// TODO これいらないのでは？
  //   final newMyStatus = await ref.read(myStatusRepositoryProvider).find(id);
  //   ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(myStatus: newMyStatus));
  // }

  Future<void> saveStatusUpEvent(bool statusUpEvent) async {
    // await _ref.read(_uiStateProvider.notifier).saveStatusUpEvent(_character.id, statusUpEvent);
    // ref.read(characterDetailIsUpdateStatus.notifier).state = true;
    // TODO saveはcharacterモデルクラスの方でやる
    final id = ref.read(_uiStateProvider).character.id;
    await ref.read(characterRepositoryProvider).saveStatusUpEvent(id, statusUpEvent);
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(statusUpEvent: statusUpEvent));
  }

  Future<void> saveHighLevel(bool useHighLevel) async {
    // await _ref.read(_uiStateProvider.notifier).saveUseHighLevel(_character.id, useHighLevel);
    // _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
    // TODO saveはcharacterモデルクラスの方でやる
    final id = ref.read(_uiStateProvider).character.id;
    await ref.read(characterRepositoryProvider).saveHighLevel(id, useHighLevel);
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(useHighLevel: useHighLevel));
  }

  Future<void> saveFavorite(bool favorite) async {
    // await _ref.read(_uiStateProvider.notifier).saveFavorite(_character.id, favorite);
    // _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
    // TODO saveはcharacterモデルクラスの方でやる
    final id = ref.read(_uiStateProvider).character.id;
    await ref.read(characterRepositoryProvider).saveFavorite(id, favorite);
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(favorite: favorite));
  }

  ///
  /// 選択したスタイルをデフォルトスタイルに更新する
  ///
  Future<void> updateDefaultStyle() async {
    // ref.read(characterDetailIsUpdateStatus.notifier).state = true;
    // TODO saveはここではやらない
    final id = ref.read(_uiStateProvider).character.id;
    final selectedStyle = ref.read(characterDetailSelectStyleStateProvider);
    await ref.read(characterRepositoryProvider).saveSelectedRank(id, selectedStyle.rank, selectedStyle.iconFilePath);
  }

  ///
  /// サーバーから最新のアイコンパスを取得し画像データを更新する
  /// 画像はキャッシュしているのでこの処理が必要
  ///
  Future<void> refreshIcon() async {
    try {
      // TODO この関数自体はcharacterモデルクラスに移動する
      final defaultStyleRank = ref.read(_uiStateProvider).character.selectedStyleRank;
      final selectedStyle = ref.read(characterDetailSelectStyleStateProvider);

      final isSelectedIcon = (defaultStyleRank == selectedStyle.rank);
      await ref.read(characterRepositoryProvider).refreshIcon(selectedStyle, isSelectedIcon);

      // await ref.read(_uiStateProvider.notifier).updateStyles(_character.id);
      final id = ref.read(_uiStateProvider).character.id;
      final newStyles = await ref.read(characterRepositoryProvider).findStyles(id);
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(styles: newStyles));

      // _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
    } catch (e, s) {
      await RSLogger.e('アイコン更新に失敗しました。', e, s);
    }
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  _UiState._(
    this.character,
    this.stage,
    this.myStatus,
    this.styles,
    this.selectedStyleRank,
    this.statusUpEvent,
    this.useHighLevel,
    this.favorite,
  );

  factory _UiState.create({required Character character, required Stage stage}) {
    return _UiState._(
      character,
      stage,
      character.myStatus,
      character.styles,
      character.selectedStyleRank,
      character.statusUpEvent,
      character.useHighLevel,
      character.favorite,
    );
  }

  factory _UiState.empty() {
    final emptyCharacter = Character(-1, '', '', [], []);
    return _UiState._(emptyCharacter, Stage.empty(), null, [], null, false, false, false);
  }

  Character character;
  Stage stage;

  MyStatus? myStatus;
  List<Style> styles;
  String? selectedStyleRank;

  bool statusUpEvent;
  bool useHighLevel;
  bool favorite;

  _UiState copyWith({
    MyStatus? myStatus,
    List<Style>? styles,
    String? selectedStyleRank,
    bool? statusUpEvent,
    bool? useHighLevel,
    bool? favorite,
  }) {
    return _UiState._(
      character,
      stage,
      myStatus ?? this.myStatus,
      styles ?? this.styles,
      selectedStyleRank ?? this.selectedStyleRank,
      statusUpEvent ?? this.statusUpEvent,
      useHighLevel ?? this.useHighLevel,
      favorite ?? this.favorite,
    );
  }
}

// キャラ自身のステータス
final characterDetailMyStatusStateProvider = Provider<MyStatus?>((ref) => ref.watch(_uiStateProvider.select((v) => v.myStatus)));

// 現在選択しているスタイル
final characterDetailSelectStyleStateProvider = Provider<Style>((ref) {
  final selectRank = ref.watch(_uiStateProvider.select((v) => v.selectedStyleRank));
  final styles = ref.watch(_uiStateProvider.select((v) => v.styles));
  return styles.firstWhereOrNull((style) => style.rank == selectRank) ?? styles.first;
});

// キャラのイベントフラグ
final characterDetailStatusUpEventStateProvider = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((v) => v.statusUpEvent)));

// キャラの難易度/周回フラグ
final characterDetailHighLevelStateProvider = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((v) => v.useHighLevel)));

// キャラのお気に入りフラグ
final characterDetailFavoriteStateProvider = Provider<bool>((ref) => ref.watch(_uiStateProvider.select((v) => v.favorite)));

// 詳細画面で更新した情報を一覧に反映したい場合はこれをtrueにする。
final characterDetailIsUpdateStatus = StateProvider((ref) => false);
