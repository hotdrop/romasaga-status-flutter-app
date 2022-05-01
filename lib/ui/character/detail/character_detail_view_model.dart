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
      _read(_characterDetailStylesProvider.notifier).refresh(_character.styles);
      _read(characterDetailSelectStyleStateProvider.notifier).state = _character.selectedStyle ?? _character.styles.first;
      _read(characterDetailMyStatusStateProvider.notifier).state = _character.myStatus;

      _read(characterDetailStatusUpEventStateProvider.notifier).state = _character.statusUpEvent;
      _read(characterDetailHighLevelStateProvider.notifier).state = _character.useHighLevel;
      _read(characterDetailFavoriteStateProvider.notifier).state = _character.favorite;
      _stage = await _read(stageRepositoryProvider).find();
    });
  }

  void onSelectRank(String rank) {
    final style = _read(_characterDetailStylesProvider.notifier).findRank(rank);
    _read(characterDetailSelectStyleStateProvider.notifier).state = style;
  }

  ///
  /// 自身のステータスを再取得する
  ///
  Future<void> refreshStatus() async {
    _read(characterDetailMyStatusStateProvider.notifier).state = await _read(myStatusRepositoryProvider).find(_character.id);
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveStatusUpEvent(bool statusUpEvent) async {
    await _read(characterRepositoryProvider).saveStatusUpEvent(_character.id, statusUpEvent);
    _read(characterDetailStatusUpEventStateProvider.notifier).state = statusUpEvent;
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveHighLevel(bool useHighLevel) async {
    await _read(characterRepositoryProvider).saveHighLevel(_character.id, useHighLevel);
    _read(characterDetailHighLevelStateProvider.notifier).state = useHighLevel;
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveFavorite(bool favorite) async {
    await _read(characterRepositoryProvider).saveFavorite(_character.id, favorite);
    _read(characterDetailFavoriteStateProvider.notifier).state = favorite;
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  ///
  /// 選択したスタイルをデフォルトスタイルに更新する
  ///
  Future<void> updateDefaultStyle() async {
    final selectedStyle = _read(characterDetailSelectStyleStateProvider)!;
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
      final selectedStyle = _read(characterDetailSelectStyleStateProvider)!;

      final isSelectedIcon = (defaultStyleRank == selectedStyle.rank);
      RSLogger.d('アイコンをサーバーから再取得します。（このアイコンをデフォルトにしているか？ $isSelectedIcon)');
      await _read(characterRepositoryProvider).refreshIcon(selectedStyle, isSelectedIcon);

      final newStyles = await _read(characterRepositoryProvider).findStyles(_character.id);
      _read(_characterDetailStylesProvider.notifier).refresh(newStyles);

      _read(characterDetailIsUpdateStatus.notifier).state = true;
    } catch (e, s) {
      await RSLogger.e('アイコン更新に失敗しました。', e, s);
    }
  }
}

// キャラ自身のステータス
final characterDetailMyStatusStateProvider = StateProvider<MyStatus?>((ref) => null);

// キャラのスタイル情報
final _characterDetailStylesProvider = StateNotifierProvider<_StylesNotifier, List<Style>>((ref) {
  return _StylesNotifier();
});

class _StylesNotifier extends StateNotifier<List<Style>> {
  _StylesNotifier() : super([]);

  void refresh(List<Style> styles) {
    state = styles;
  }

  Style findRank(String rank) {
    return state.firstWhere((style) => style.rank == rank);
  }
}

// 現在選択しているスタイル
final characterDetailSelectStyleStateProvider = StateProvider<Style?>((ref) => null);

// キャラのイベントフラグ
final characterDetailStatusUpEventStateProvider = StateProvider<bool>((ref) => false);

// キャラの難易度/周回フラグ
final characterDetailHighLevelStateProvider = StateProvider<bool>((ref) => false);

// キャラのお気に入りフラグ
final characterDetailFavoriteStateProvider = StateProvider<bool>((ref) => false);

// 詳細画面で更新した情報を一覧に反映したい場合はこれをtrueにする。
final characterDetailIsUpdateStatus = StateProvider((ref) => false);
