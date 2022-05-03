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
  return _CharacterDetailViewModel(ref.read, c);
});

class _CharacterDetailViewModel extends StateNotifier<AsyncValue<void>> {
  _CharacterDetailViewModel(this._read, this._character) : super(const AsyncValue.loading());

  final Reader _read;

  final Character _character;
  late Stage _stage;

  // キャラ情報
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
      _read(_characterDetailUiStateProvider.notifier).init(_character);
      _stage = await _read(stageRepositoryProvider).find();
    });
  }

  void onSelectRank(String rank) {
    _read(_characterDetailUiStateProvider.notifier).selectRank(rank);
  }

  ///
  /// 自身のステータスを再取得する
  ///
  Future<void> refreshMyStatus() async {
    await _read(_characterDetailUiStateProvider.notifier).updateMyStatus(_character.id);
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveStatusUpEvent(bool statusUpEvent) async {
    await _read(_characterDetailUiStateProvider.notifier).saveStatusUpEvent(_character.id, statusUpEvent);
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveHighLevel(bool useHighLevel) async {
    await _read(_characterDetailUiStateProvider.notifier).saveUseHighLevel(_character.id, useHighLevel);
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveFavorite(bool favorite) async {
    await _read(_characterDetailUiStateProvider.notifier).saveFavorite(_character.id, favorite);
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  ///
  /// 選択したスタイルをデフォルトスタイルに更新する
  ///
  Future<void> updateDefaultStyle() async {
    final selectedStyle = _read(characterDetailSelectStyleStateProvider);
    RSLogger.d('表示ランクを ${selectedStyle.rank} にします。');
    await _read(characterRepositoryProvider).saveSelectedRank(_character.id, selectedStyle.rank, selectedStyle.iconFilePath);
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  ///
  /// サーバーから最新のアイコンパスを取得し画像データを更新する
  /// 画像はキャッシュしているのでこの処理が必要
  ///
  Future<void> refreshIcon() async {
    try {
      final defaultStyleRank = _character.selectedStyleRank;
      final selectedStyle = _read(characterDetailSelectStyleStateProvider);

      final isSelectedIcon = (defaultStyleRank == selectedStyle.rank);
      await _read(characterRepositoryProvider).refreshIcon(selectedStyle, isSelectedIcon);

      await _read(_characterDetailUiStateProvider.notifier).updateStyles(_character.id);

      _read(characterDetailIsUpdateStatus.notifier).state = true;
    } catch (e, s) {
      await RSLogger.e('アイコン更新に失敗しました。', e, s);
    }
  }
}

// 画面の状態
final _characterDetailUiStateProvider = StateNotifierProvider<_UiStateNotifer, _UiState>((ref) {
  return _UiStateNotifer(ref.read, _UiState.empty());
});

class _UiStateNotifer extends StateNotifier<_UiState> {
  _UiStateNotifer(this._read, _UiState state) : super(state);

  final Reader _read;

  void init(Character c) {
    state = _UiState(c.myStatus, c.styles, c.selectedStyleRank, c.statusUpEvent, c.useHighLevel, c.favorite);
  }

  void selectRank(String rank) {
    state = state.copyWith(selectStyleRank: rank);
  }

  Future<void> updateStyles(int id) async {
    final newStyles = await _read(characterRepositoryProvider).findStyles(id);
    state = state.copyWith(styles: newStyles);
  }

  Future<void> updateMyStatus(int id) async {
    final newMyStatus = await _read(myStatusRepositoryProvider).find(id);
    state = state.copyWith(myStatus: newMyStatus);
  }

  Future<void> saveStatusUpEvent(int id, bool newVal) async {
    await _read(characterRepositoryProvider).saveStatusUpEvent(id, newVal);
    state = state.copyWith(statusUpEvent: newVal);
  }

  Future<void> saveUseHighLevel(int id, bool newVal) async {
    await _read(characterRepositoryProvider).saveHighLevel(id, newVal);
    state = state.copyWith(useHighLevel: newVal);
  }

  Future<void> saveFavorite(int id, bool newVal) async {
    await _read(characterRepositoryProvider).saveFavorite(id, newVal);
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
final characterDetailMyStatusStateProvider = Provider<MyStatus?>((ref) {
  return ref.watch(_characterDetailUiStateProvider.select((v) => v.myStatus));
});

// 現在選択しているスタイル
final characterDetailSelectStyleStateProvider = Provider<Style>((ref) {
  final selectRank = ref.watch(_characterDetailUiStateProvider.select((v) => v.selectStyleRank));
  final styles = ref.watch(_characterDetailUiStateProvider.select((v) => v.styles));
  return styles.firstWhereOrNull((style) => style.rank == selectRank) ?? styles.first;
});

// キャラのイベントフラグ
final characterDetailStatusUpEventStateProvider = Provider<bool>((ref) {
  return ref.watch(_characterDetailUiStateProvider.select((v) => v.statusUpEvent));
});

// キャラの難易度/周回フラグ
final characterDetailHighLevelStateProvider = Provider<bool>((ref) {
  return ref.watch(_characterDetailUiStateProvider.select((v) => v.useHighLevel));
});

// キャラのお気に入りフラグ
final characterDetailFavoriteStateProvider = Provider<bool>((ref) {
  return ref.watch(_characterDetailUiStateProvider.select((v) => v.favorite));
});

// 詳細画面で更新した情報を一覧に反映したい場合はこれをtrueにする。
final characterDetailIsUpdateStatus = StateProvider((ref) => false);
