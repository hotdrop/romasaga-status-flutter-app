import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/models/style.dart';
import 'package:rsapp/ui/base_view_model.dart';

final characterDetailViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CharacterDetailViewModel(ref.read));

class _CharacterDetailViewModel extends BaseViewModel {
  _CharacterDetailViewModel(this._read);

  final Reader _read;

  late Character character;
  bool get haveAttribute => character.attributes?.isNotEmpty ?? false;
  int get myTotalStatus => character.myStatus?.sumWithoutHp() ?? 0;

  late Stage _stage;
  Stage get stage => _stage;

  late Style _selectedStyle;
  String get selectedIconFilePath => _selectedStyle.iconFilePath;
  String get selectedStyleTitle => _selectedStyle.title;
  String get selectedRankName => character.selectedStyleRank ?? character.styles.first.rank;

  int get totalLimitStatusWithSelectedStage => (_selectedStyle.sum()) + (8 * _stage.statusLimit);

  // 詳細画面で更新した情報を一覧に反映したい場合はこれをtrueにする。
  // TODO このフラグはよくないのでキャラデータをStateNotifierで持って更新判定する。
  bool _isUpdateStatus = false;
  bool get isUpdate => _isUpdateStatus;

  Future<void> init(Character character) async {
    try {
      character = character;
      _stage = await _read(stageRepositoryProvider).find();

      if (character.styles.isEmpty) {
        RSLogger.d('キャラクターのスタイルが未取得なので取得します。id=${character.id}');
        final styles = await _read(characterRepositoryProvider).findStyles(character.id);
        RSLogger.d('キャラクターのスタイルを取得しました。件数=${styles.length}');
        character.addStyles(styles);
      }

      _selectedStyle = character.selectedStyle ?? character.styles.first;
      onSuccess();
    } on Exception catch (e) {
      onError('$e');
    }
  }

  void onSelectRank(String rank) {
    _selectedStyle = character.getStyle(rank);
    notifyListeners();
  }

  List<String> getAllRanks() {
    final ranks = character.styles.map((style) => style.rank).toList();
    return ranks..sort((s, t) => s.compareTo(t));
  }

  int getStatusLimit(String statusName) {
    switch (statusName) {
      case RSStrings.strName:
        return _selectedStyle.str + _stage.statusLimit;
      case RSStrings.vitName:
        return _selectedStyle.vit + _stage.statusLimit;
      case RSStrings.dexName:
        return _selectedStyle.dex + _stage.statusLimit;
      case RSStrings.agiName:
        return _selectedStyle.agi + _stage.statusLimit;
      case RSStrings.intName:
        return _selectedStyle.intelligence + _stage.statusLimit;
      case RSStrings.spiName:
        return _selectedStyle.spirit + _stage.statusLimit;
      case RSStrings.loveName:
        return _selectedStyle.love + _stage.statusLimit;
      case RSStrings.attrName:
        return _selectedStyle.attr + _stage.statusLimit;
      default:
        return 1;
    }
  }

  Future<void> refreshStatus() async {
    character.myStatus = await _read(myStatusRepositoryProvider).find(character.id);
    refreshCharacterData();
  }

  Future<void> saveCurrentSelectStyle() async {
    RSLogger.d('表示ランクを ${_selectedStyle.rank} にします。');
    character.selectedStyleRank = _selectedStyle.rank;
    character.selectedIconFilePath = _selectedStyle.iconFilePath;
    await _read(characterRepositoryProvider).saveSelectedRank(character.id, _selectedStyle.rank, _selectedStyle.iconFilePath);

    _isUpdateStatus = true;
  }

  Future<void> saveFavorite(bool favorite) async {
    if (character.myStatus != null) {
      character.myStatus!.favorite = favorite;
    } else {
      character.myStatus = MyStatus(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, favorite);
    }

    await _read(myStatusRepositoryProvider).save(character.myStatus!);

    refreshCharacterData();
  }

  Future<void> saveStatusUpEvent(int id, bool statusUpEvent) async {
    character.statusUpEvent = statusUpEvent;
    await _read(characterRepositoryProvider).saveStatusUpEvent(id, statusUpEvent);

    refreshCharacterData();
  }

  ///
  /// アイコンの更新処理ではrefreshCharacterDataを実行しないので画面状態はそのままになる。
  /// そのため呼び元でrefreshCharacterDataを実行する
  ///
  Future<bool> refreshIcon() async {
    try {
      final isSelectedIcon = _selectedStyle.rank == character.selectedStyleRank;
      RSLogger.d('アイコンをサーバーから再取得します。（このアイコンをデフォルトにしているか？ $isSelectedIcon)');
      await _read(characterRepositoryProvider).refreshIcon(_selectedStyle, isSelectedIcon);

      RSLogger.d('アイコン情報をキャラ情報に反映します。');
      final styles = await _read(characterRepositoryProvider).findStyles(character.id);
      character.refreshStyles(styles);

      return true;
    } on Exception catch (e, s) {
      await RSLogger.e('アイコン更新に失敗しました。', exception: e, stackTrace: s);
      return false;
    }
  }

  void refreshCharacterData() {
    _isUpdateStatus = true;
    notifyListeners();
  }
}
