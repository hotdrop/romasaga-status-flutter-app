import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/models/style.dart';
import 'package:collection/collection.dart';

part 'character_detail_providers.g.dart';

@riverpod
class CharacterDetailController extends _$CharacterDetailController {
  @override
  Future<void> build(int id) async {
    // ここで_uiStateProviderを同期更新してしまうとWidgetのbuild中に更新することになるので非同期にする・・なんかいい方法ないかなここ
    Future<void>.delayed(Duration.zero).then((_) {
      ref.read(_uiStateProvider.notifier).state = _UiState.create(id: id);
    });
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
          selectedStyle: ref.read(characterDetailSelectStyleProvider),
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
            selectedStyle: ref.read(characterDetailSelectStyleProvider),
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

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.create(id: Character.noneId));

class _UiState {
  _UiState._(
    this.characterId,
    this.selectedStyleRank,
  );

  factory _UiState.create({required int id}) {
    return _UiState._(id, null);
  }

  int characterId;
  String? selectedStyleRank;

  _UiState copyWith({
    String? selectedStyleRank,
  }) {
    return _UiState._(
      characterId,
      selectedStyleRank ?? this.selectedStyleRank,
    );
  }
}

// キャラ情報
final characterDetailCharaProvider = Provider<Character>((ref) {
  final id = ref.watch(_uiStateProvider.select((value) => value.characterId));
  return ref.watch(characterProvider.select((c) => c.firstWhereOrNull((c) => c.id == id) ?? Character.empty()));
});

// ステージ情報
final characterDetailStageProvider = Provider<Stage>((ref) {
  return ref.watch(stageProvider);
});

// 現在選択しているスタイル
final characterDetailSelectStyleProvider = Provider<Style>((ref) {
  final styles = ref.watch(characterDetailCharaProvider).styles;
  final selectRank = ref.watch(_uiStateProvider.select((v) => v.selectedStyleRank));
  return styles.firstWhereOrNull((style) => style.rank == selectRank) ?? styles.first;
});

// キャラのイベントフラグ
final characterDetailStatusUpEventProvider = Provider<bool>((ref) {
  return ref.watch(characterDetailCharaProvider.select((v) => v.statusUpEvent));
});

// キャラの難易度/周回フラグ
final characterDetailHighLevelProvider = Provider<bool>((ref) {
  return ref.watch(characterDetailCharaProvider.select((v) => v.useHighLevel));
});

// キャラのお気に入りフラグ
final characterDetailFavoriteProvider = Provider<bool>((ref) {
  return ref.watch(characterDetailCharaProvider.select((v) => v.favorite));
});
