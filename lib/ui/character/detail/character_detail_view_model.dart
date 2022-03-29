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
import 'package:rsapp/ui/base_view_model.dart';

final characterDetailViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CharacterDetailViewModel(ref.read));

// キャラ自身のステータス
final characterDetailStatusStateProvider = StateProvider<MyStatus?>((ref) => null);

final characterDetailStatusUpEventStateProvider = StateProvider((ref) => false);
final characterDetailHighLevelStateProvider = StateProvider((ref) => false);
final characterDetailFavoriteStateProvider = StateProvider((ref) => false);

// 現在選択しているスタイル
final characterDetailSelectStyleStateProvider = StateProvider<Style?>((_) => null);

// 現在登録されているステージのステータス上限値
final characterDetailLimitStatus = StateProvider((ref) => 0);

final characterDetailLimitStr = StateProvider((ref) {
  final status = ref.watch(characterDetailSelectStyleStateProvider)?.str ?? 0;
  final limit = ref.watch(characterDetailLimitStatus);
  return status + limit;
});

final characterDetailLimitVit = StateProvider((ref) {
  final status = ref.watch(characterDetailSelectStyleStateProvider)?.vit ?? 0;
  final limit = ref.watch(characterDetailLimitStatus);
  return status + limit;
});

final characterDetailLimitDex = StateProvider((ref) {
  final status = ref.watch(characterDetailSelectStyleStateProvider)?.dex ?? 0;
  final limit = ref.watch(characterDetailLimitStatus);
  return status + limit;
});

final characterDetailLimitAgi = StateProvider((ref) {
  final status = ref.watch(characterDetailSelectStyleStateProvider)?.agi ?? 0;
  final limit = ref.watch(characterDetailLimitStatus);
  return status + limit;
});

final characterDetailLimitInt = StateProvider((ref) {
  final status = ref.watch(characterDetailSelectStyleStateProvider)?.intelligence ?? 0;
  final limit = ref.watch(characterDetailLimitStatus);
  return status + limit;
});

final characterDetailLimitSpi = StateProvider((ref) {
  final status = ref.watch(characterDetailSelectStyleStateProvider)?.spirit ?? 0;
  final limit = ref.watch(characterDetailLimitStatus);
  return status + limit;
});

final characterDetailLimitLove = StateProvider((ref) {
  final status = ref.watch(characterDetailSelectStyleStateProvider)?.love ?? 0;
  final limit = ref.watch(characterDetailLimitStatus);
  return status + limit;
});

final characterDetailLimitAttr = StateProvider((ref) {
  final status = ref.watch(characterDetailSelectStyleStateProvider)?.attr ?? 0;
  final limit = ref.watch(characterDetailLimitStatus);
  return status + limit;
});

// 詳細画面で更新した情報を一覧に反映したい場合はこれをtrueにする。
final characterDetailIsUpdateStatus = StateProvider((ref) => false);

class _CharacterDetailViewModel extends BaseViewModel {
  _CharacterDetailViewModel(this._read);

  final Reader _read;

  late Character _character;
  String get production => _character.production;
  String get name => _character.name;
  List<Weapon> get weapons => _character.weapons;
  List<Attribute>? get attributes => _character.attributes;

  late final Stage _stage;
  String get stageName => _stage.name;
  int get stageHpLimit => _stage.hpLimit;

  Future<void> init(Character c) async {
    try {
      _character = c;
      _stage = await _read(stageRepositoryProvider).find();

      _read(characterDetailLimitStatus.notifier).state = _stage.statusLimit;
      _read(characterDetailSelectStyleStateProvider.notifier).state = c.selectedStyle ?? c.styles.first;

      _read(characterDetailStatusStateProvider.notifier).state = c.myStatus;
      _read(characterDetailStatusUpEventStateProvider.notifier).state = c.statusUpEvent;
      _read(characterDetailHighLevelStateProvider.notifier).state = c.useHighLevel;
      _read(characterDetailFavoriteStateProvider.notifier).state = c.favorite;
      onSuccess();
    } catch (e, s) {
      RSLogger.e('キャラ詳細情報取得でエラー', e, s);
      onError('$e');
    }
  }

  List<String> getAllRanks() {
    return _character.styles.map((style) => style.rank).toList()..sort((s, t) => s.compareTo(t));
  }

  void onSelectRank(String rank) {
    _read(characterDetailSelectStyleStateProvider.notifier).state = _character.getStyle(rank);
  }

  Future<void> refreshStatus() async {
    final newStatus = await _read(myStatusRepositoryProvider).find(_character.id);
    if (newStatus == null) {
      return;
    }

    // 自身のステータスを更新
    _character = _character.copyWith(myStatus: newStatus);
    _read(characterDetailStatusStateProvider.notifier).state = newStatus;
    _read(characterDetailIsUpdateStatus.notifier).state = true;
  }

  Future<void> saveCurrentSelectStyle() async {
    final selectedStyle = _read(characterDetailSelectStyleStateProvider)!;
    RSLogger.d('表示ランクを ${selectedStyle.rank} にします。');

    await _read(characterRepositoryProvider).saveSelectedRank(_character.id, selectedStyle.rank, selectedStyle.iconFilePath);

    _character = _character.copyWith(
      selectedStyleRank: selectedStyle.rank,
      selectedIconFilePath: selectedStyle.iconFilePath,
    );
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
  /// サーバーから最新のアイコンパスを取得し画像データを更新する
  /// 画像はキャッシュしているのでこの処理が必要
  ///
  Future<void> refreshIcon() async {
    try {
      final selectedStyle = _read(characterDetailSelectStyleStateProvider)!;
      final isSelectedIcon = (_character.selectedStyleRank == selectedStyle.rank);
      RSLogger.d('アイコンをサーバーから再取得します。（このアイコンをデフォルトにしているか？ $isSelectedIcon)');
      await _read(characterRepositoryProvider).refreshIcon(selectedStyle, isSelectedIcon);

      RSLogger.d('アイコン情報をキャラ情報に反映します。');
      final styles = await _read(characterRepositoryProvider).findStyles(_character.id);
      _character.refreshStyles(styles);

      _read(characterDetailIsUpdateStatus.notifier).state = true;
    } catch (e, s) {
      await RSLogger.e('アイコン更新に失敗しました。', e, s);
    }
  }
}
