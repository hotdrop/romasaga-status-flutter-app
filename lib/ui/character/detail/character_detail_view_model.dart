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

  late Character _character;
  Character get character => _character;

  late Stage _stage;
  Stage get stage => _stage;

  late Style _selectedStyle;
  Style get selectedStyle => _selectedStyle;

  // 詳細画面で更新した情報を一覧に反映したい場合はこれをtrueにする。
  bool _isUpdateStatus = false;
  bool get isUpdate => _isUpdateStatus;

  int get statusLimitStr => _selectedStyle.str + _stage.statusLimit;
  int get statusLimitVit => _selectedStyle.vit + _stage.statusLimit;
  int get statusLimitDex => _selectedStyle.dex + _stage.statusLimit;
  int get statusLimitAgi => _selectedStyle.agi + _stage.statusLimit;
  int get statusLimitInt => _selectedStyle.intelligence + _stage.statusLimit;
  int get statusLimitSpi => _selectedStyle.spirit + _stage.statusLimit;
  int get statusLimitLove => _selectedStyle.love + _stage.statusLimit;
  int get statusLimitAttr => _selectedStyle.attr + _stage.statusLimit;

  List<String> get allRanks => _character.styles.map((style) => style.rank).toList()..sort((s, t) => s.compareTo(t));

  Future<void> init(Character c) async {
    try {
      _character = c;
      _stage = await _read(stageRepositoryProvider).find();
      _selectedStyle = c.selectedStyle ?? c.styles.first;
      onSuccess();
    } catch (e, s) {
      RSLogger.e('キャラ詳細情報取得でエラー', e, s);
      onError('$e');
    }
  }

  void onSelectRank(String rank) {
    _selectedStyle = _character.getStyle(rank);
    notifyListeners();
  }

  Future<void> refreshStatus() async {
    _character.myStatus = await _read(myStatusRepositoryProvider).find(_character.id);
    refreshCharacterData();
  }

  Future<void> saveCurrentSelectStyle() async {
    RSLogger.d('表示ランクを ${_selectedStyle.rank} にします。');
    _character.selectedStyleRank = _selectedStyle.rank;
    _character.selectedIconFilePath = _selectedStyle.iconFilePath;
    await _read(characterRepositoryProvider).saveSelectedRank(_character.id, _selectedStyle.rank, _selectedStyle.iconFilePath);
    _isUpdateStatus = true;
  }

  Future<void> saveFavorite(bool favorite) async {
    _character.myStatus ??= MyStatus.empty(_character.id);
    _character.myStatus!.favorite = favorite;
    await _read(myStatusRepositoryProvider).save(_character.myStatus!);
    _isUpdateStatus = true;
  }

  Future<void> saveStatusUpEvent(bool statusUpEvent) async {
    _character.statusUpEvent = statusUpEvent;
    await _read(characterRepositoryProvider).saveStatusUpEvent(_character.id, statusUpEvent);
    _isUpdateStatus = true;
  }

  Future<void> saveHighLevel(bool useHighLevel) async {
    _character.myStatus ??= MyStatus.empty(_character.id);
    _character.myStatus!.useHighLevel = useHighLevel;
    await _read(myStatusRepositoryProvider).save(_character.myStatus!);
    _isUpdateStatus = true;
  }

  ///
  /// アイコンの更新処理ではrefreshCharacterDataを実行しないので画面状態はそのままになる。
  /// そのため呼び元でrefreshCharacterDataを実行する
  ///
  Future<bool> refreshIcon() async {
    try {
      final isSelectedIcon = _selectedStyle.rank == _character.selectedStyleRank;
      RSLogger.d('アイコンをサーバーから再取得します。（このアイコンをデフォルトにしているか？ $isSelectedIcon)');
      await _read(characterRepositoryProvider).refreshIcon(_selectedStyle, isSelectedIcon);

      RSLogger.d('アイコン情報をキャラ情報に反映します。');
      final styles = await _read(characterRepositoryProvider).findStyles(_character.id);
      _character.refreshStyles(styles);

      return true;
    } catch (e, s) {
      await RSLogger.e('アイコン更新に失敗しました。', e, s);
      return false;
    }
  }

  void refreshCharacterData() {
    _isUpdateStatus = true;
    notifyListeners();
  }
}
