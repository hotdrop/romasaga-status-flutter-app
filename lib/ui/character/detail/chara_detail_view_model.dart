import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/models/style.dart';
import 'package:collection/collection.dart';

part 'chara_detail_view_model.g.dart';

@riverpod
class CharacterDetailViewModel extends _$CharacterDetailViewModel {
  @override
  Future<void> build(int id) async {
    final stage = await ref.read(stageRepositoryProvider).find();
    ref.read(_uiStateProvider.notifier).state = _UiState.create(id: id, stage: stage);
  }
}

@riverpod
class CharacterDetailMethods extends _$CharacterDetailMethods {
  @override
  void build() {}

  ///
  /// 選択したスタイルをデフォルトスタイルに更新する
  ///
  Future<void> updateDefaultStyle() async {
    await ref.read(characterProvider.notifier).updateDefaultStyle(
          selectedCharacterId: ref.read(characterDetailCharaProvider).id,
          selectedStyle: ref.read(characterDetailSelectStyleStateProvider),
        );
  }

  ///
  /// 選択したランクに切り替える
  ///
  void onSelectRank(String rank) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(selectedStyleRank: rank));
  }

  ///
  /// サーバーから最新のアイコンパスを取得し画像データを更新する
  /// 画像はキャッシュしているのでこの処理が必要
  ///
  Future<void> refreshIcon() async {
    try {
      await ref.read(characterProvider.notifier).refreshIcon(
            id: ref.read(characterDetailCharaProvider).id,
            selectedStyle: ref.read(characterDetailSelectStyleStateProvider),
          );
    } catch (e, s) {
      await RSLogger.e('アイコン更新に失敗しました。', e, s);
    }
  }

  Future<void> saveStatusUpEvent(bool statusUpEvent) async {
    await ref.read(characterProvider.notifier).saveStatusUpEvent(
          id: ref.read(characterDetailCharaProvider).id,
          statusUpEvent: statusUpEvent,
        );
  }

  Future<void> saveHighLevel(bool useHighLevel) async {
    await ref.read(characterProvider.notifier).saveHighLevel(
          id: ref.read(characterDetailCharaProvider).id,
          useHighLevel: useHighLevel,
        );
  }

  Future<void> saveFavorite(bool favorite) async {
    await ref.read(characterProvider.notifier).saveFavorite(
          id: ref.read(characterDetailCharaProvider).id,
          favorite: favorite,
        );
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  _UiState._(
    this.characterId,
    this.stage,
    this.selectedStyleRank,
  );

  factory _UiState.create({required int id, required Stage stage}) {
    return _UiState._(id, stage, null);
  }

  factory _UiState.empty() {
    return _UiState._(-1, Stage.empty(), null);
  }

  int characterId;
  Stage stage;
  String? selectedStyleRank;

  _UiState copyWith({
    String? selectedStyleRank,
  }) {
    return _UiState._(
      characterId,
      stage,
      selectedStyleRank ?? this.selectedStyleRank,
    );
  }
}

// キャラ情報
final characterDetailCharaProvider = Provider<Character>((ref) {
  final id = ref.watch(_uiStateProvider.select((value) => value.characterId));
  return ref.watch(characterProvider.select((c) => c.firstWhere((c) => c.id == id)));
});

// ステージ情報
final characterDetailStageProvider = Provider<Stage>((ref) {
  return ref.watch(_uiStateProvider.select((v) => v.stage));
});

// 現在選択しているスタイル
final characterDetailSelectStyleStateProvider = Provider<Style>((ref) {
  final styles = ref.watch(characterDetailCharaProvider).styles;
  final selectRank = ref.watch(_uiStateProvider.select((v) => v.selectedStyleRank));
  return styles.firstWhereOrNull((style) => style.rank == selectRank) ?? styles.first;
});

// キャラのイベントフラグ
final characterDetailStatusUpEventStateProvider = Provider<bool>((ref) {
  return ref.watch(characterDetailCharaProvider.select((v) => v.statusUpEvent));
});

// キャラの難易度/周回フラグ
final characterDetailHighLevelStateProvider = Provider<bool>((ref) {
  return ref.watch(characterDetailCharaProvider.select((v) => v.useHighLevel));
});

// キャラのお気に入りフラグ
final characterDetailFavoriteStateProvider = Provider<bool>((ref) {
  return ref.watch(characterDetailCharaProvider.select((v) => v.favorite));
});
