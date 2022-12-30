import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:collection/collection.dart';

///
/// ViewModelのProvider（override用）
///
final characterDetailViewModel = StateNotifierProvider.autoDispose<_CharacterDetailViewModel, AsyncValue<void>>((ref) {
  throw UnimplementedError();
});

///
/// ViewModelの引数付きProvider
///
final characterDetailFamilyViewModel = StateNotifierProvider.autoDispose.family<_CharacterDetailViewModel, AsyncValue<void>, Character>((ref, c) {
  return _CharacterDetailViewModel(ref, c);
});

class _CharacterDetailViewModel extends StateNotifier<AsyncValue<void>> {
  _CharacterDetailViewModel(this._ref, this._character) : super(const AsyncValue.loading());

  final Ref _ref;

  final Character _character;
  late Stage _stage;

  // キャラ情報
  int get id => _character.id;
  List<String> get allRank => _character.allRank;
  String get production => _character.production;
  String get name => _character.name;
  List<Weapon> get weapons => _character.weapons;
  List<Attribute>? get attributes => _character.attributes;

  // ステージ情報
  String get stageName => _stage.name;
  int get hpLimit => _stage.hpLimit;
  int get statusLimit => _stage.statusLimit;

  ///
  /// これ本当はクラス構築時に自動で実行したかったが、それやったらStateProviderの構築時に他のProviderを初期化してはならないとエラーで怒られた。
  /// そのためLoading処理でViewから別途よぶことにした。
  ///
  Future<void> init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _ref.read(_uiStateProvider.notifier).init(_character);
      _stage = await _ref.read(stageRepositoryProvider).find();
    });
  }

  void onSelectRank(String rank) {
    _ref.read(_uiStateProvider.notifier).selectRank(rank);
  }

  ///
  /// 自身のステータスを再取得する
  ///
  Future<void> refreshMyStatus() async {
    await _ref.read(_uiStateProvider.notifier).updateMyStatus(_character.id);
    _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveStatusUpEvent(bool statusUpEvent) async {
    await _ref.read(_uiStateProvider.notifier).saveStatusUpEvent(_character.id, statusUpEvent);
    _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveHighLevel(bool useHighLevel) async {
    await _ref.read(_uiStateProvider.notifier).saveUseHighLevel(_character.id, useHighLevel);
    _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveFavorite(bool favorite) async {
    await _ref.read(_uiStateProvider.notifier).saveFavorite(_character.id, favorite);
    _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  ///
  /// 選択したスタイルをデフォルトスタイルに更新する
  ///
  Future<void> updateDefaultStyle() async {
    final selectedStyle = _ref.read(characterDetailSelectStyleStateProvider);
    RSLogger.d('表示ランクを ${selectedStyle.rank} にします。');
    await _ref.read(characterRepositoryProvider).saveSelectedRank(_character.id, selectedStyle.rank, selectedStyle.iconFilePath);
    _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  ///
  /// サーバーから最新のアイコンパスを取得し画像データを更新する
  /// 画像はキャッシュしているのでこの処理が必要
  ///
  Future<void> refreshIcon() async {
    try {
      final defaultStyleRank = _character.selectedStyleRank;
      final selectedStyle = _ref.read(characterDetailSelectStyleStateProvider);

      final isSelectedIcon = (defaultStyleRank == selectedStyle.rank);
      await _ref.read(characterRepositoryProvider).refreshIcon(selectedStyle, isSelectedIcon);

      await _ref.read(_uiStateProvider.notifier).updateStyles(_character.id);

      _ref.read(characterDetailIsUpdateStatus.notifier).state = true;
    } catch (e, s) {
      await RSLogger.e('アイコン更新に失敗しました。', e, s);
    }
  }
}

// 画面の状態
final _uiStateProvider = StateNotifierProvider<_UiStateNotifer, _UiState>((ref) {
  return _UiStateNotifer(ref, _UiState.empty());
});

class _UiStateNotifer extends StateNotifier<_UiState> {
  _UiStateNotifer(this._ref, _UiState state) : super(state);

  final Ref _ref;

  void init(Character c) {
    state = _UiState(c.myStatus, c.styles, c.selectedStyleRank, c.statusUpEvent, c.useHighLevel, c.favorite);
  }

  void selectRank(String rank) {
    state = state.copyWith(selectStyleRank: rank);
  }

  Future<void> updateStyles(int id) async {
    final newStyles = await _ref.read(characterRepositoryProvider).findStyles(id);
    state = state.copyWith(styles: newStyles);
  }

  Future<void> updateMyStatus(int id) async {
    final newMyStatus = await _ref.read(myStatusRepositoryProvider).find(id);
    state = state.copyWith(myStatus: newMyStatus);
  }

  Future<void> saveStatusUpEvent(int id, bool newVal) async {
    await _ref.read(characterRepositoryProvider).saveStatusUpEvent(id, newVal);
    state = state.copyWith(statusUpEvent: newVal);
  }

  Future<void> saveUseHighLevel(int id, bool newVal) async {
    await _ref.read(characterRepositoryProvider).saveHighLevel(id, newVal);
    state = state.copyWith(useHighLevel: newVal);
  }

  Future<void> saveFavorite(int id, bool newVal) async {
    await _ref.read(characterRepositoryProvider).saveFavorite(id, newVal);
    state = state.copyWith(favorite: newVal);
  }
}

class _UiState {
  _UiState(this.myStatus, this.styles, this.selectStyleRank, this.statusUpEvent, this.useHighLevel, this.favorite);

  factory _UiState.empty() {
    return _UiState(null, [], null, false, false, false);
  }

  MyStatus? myStatus;
  List<Style> styles;
  String? selectStyleRank;

  bool statusUpEvent;
  bool useHighLevel;
  bool favorite;

  _UiState copyWith({MyStatus? myStatus, List<Style>? styles, String? selectStyleRank, bool? statusUpEvent, bool? useHighLevel, bool? favorite}) {
    return _UiState(
      myStatus ?? this.myStatus,
      styles ?? this.styles,
      selectStyleRank ?? this.selectStyleRank,
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
  final selectRank = ref.watch(_uiStateProvider.select((v) => v.selectStyleRank));
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
