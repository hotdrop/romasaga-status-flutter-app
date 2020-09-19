import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/data/character_repository.dart';
import 'package:rsapp/romasaga/data/my_status_repository.dart';
import 'package:rsapp/romasaga/data/stage_repository.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/stage.dart';
import 'package:rsapp/romasaga/model/style.dart';
import 'package:rsapp/romasaga/ui/change_notifier_view_model.dart';

class CharDetailViewModel extends ChangeNotifierViewModel {
  CharDetailViewModel._(this.character, this._characterRepository, this._stageRepository, this._myStatusRepository);

  factory CharDetailViewModel.create(Character character) {
    return CharDetailViewModel._(
      character,
      CharacterRepository.create(),
      StageRepository.create(),
      MyStatusRepository.create(),
    );
  }

  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;
  final MyStatusRepository _myStatusRepository;

  final Character character;

  bool get haveAttribute => character.attributes?.isNotEmpty ?? false;

  int get myTotalStatus => character.myStatus.sumWithoutHp();

  List<Stage> _stages;

  List<Stage> get stages => _stages ?? [];

  Style _selectedStyle;
  Stage _selectedStage;

  String get selectedIconFilePath => _selectedStyle?.iconFilePath ?? 'default';

  String get selectedStyleTitle => _selectedStyle?.title ?? '';

  // 詳細画面で更新した情報を一覧に反映したい場合はこれをtrueにする。
  bool _isUpdateStatus = false;

  bool get isUpdate => _isUpdateStatus;

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    await run(
        label: 'キャラ詳細のロード処理',
        block: () async {
          _stages = await _stageRepository.findAll();
          _selectedStage = _stages.first;

          if (character.styles.isEmpty) {
            RSLogger.d('キャラクターのスタイルが未取得なので取得します。id=${character.id}');
            final styles = await _characterRepository.findStyles(character.id);
            RSLogger.d('キャラクターのスタイルを取得しました。件数=${styles.length}');
            character.addStyles(styles);
          }

          _selectedStyle = character.selectedStyle;
        });
  }

  void onSelectRank(String rank) {
    _selectedStyle = character.getStyle(rank);
    notifyListeners();
  }

  List<String> getAllRanks() {
    final ranks = character.styles.map((style) => style.rank).toList();
    return ranks..sort((s, t) => s.compareTo(t));
  }

  String getSelectedStageName() {
    return _selectedStage?.name;
  }

  int getSelectedStageLimit() {
    return _selectedStage.limit ?? 0;
  }

  int getTotalLimitStatusWithSelectedStage() {
    return _selectedStyle.sum() + (8 * _selectedStage.limit);
  }

  void onSelectStage(String stageName) {
    _selectedStage = _stages.firstWhere((s) => s.name == stageName);
    notifyListeners();
  }

  int getStatusLimit(String statusName) {
    int targetStatus;
    switch (statusName) {
      case RSStrings.strName:
        targetStatus = _selectedStyle?.str;
        break;
      case RSStrings.vitName:
        targetStatus = _selectedStyle?.vit;
        break;
      case RSStrings.dexName:
        targetStatus = _selectedStyle?.dex;
        break;
      case RSStrings.agiName:
        targetStatus = _selectedStyle?.agi;
        break;
      case RSStrings.intName:
        targetStatus = _selectedStyle?.intelligence;
        break;
      case RSStrings.spiName:
        targetStatus = _selectedStyle?.spirit;
        break;
      case RSStrings.loveName:
        targetStatus = _selectedStyle?.love;
        break;
      case RSStrings.attrName:
        targetStatus = _selectedStyle?.attr;
        break;
      default:
        targetStatus = null;
        break;
    }

    if (targetStatus == null) {
      return 1;
    }
    return targetStatus + _selectedStage.limit;
  }

  Future<void> refreshStatus() async {
    character.myStatus = await _myStatusRepository.find(character.id);
    refreshCharacterData();
  }

  Future<void> saveCurrentSelectStyle() async {
    RSLogger.d('表示ランクを ${_selectedStyle.rank} にします。');
    character.selectedStyleRank = _selectedStyle.rank;
    character.selectedIconFilePath = _selectedStyle.iconFilePath;
    await _characterRepository.saveSelectedRank(character.id, _selectedStyle.rank, _selectedStyle.iconFilePath);

    _isUpdateStatus = true;
  }

  Future<void> saveFavorite(bool favorite) async {
    character.myStatus.favorite = favorite;
    await _myStatusRepository.save(character.myStatus);

    refreshCharacterData();
  }

  Future<void> saveStatusUpEvent(int id, bool statusUpEvent) async {
    character.statusUpEvent = statusUpEvent;
    await _characterRepository.saveStatusUpEvent(id, statusUpEvent);

    refreshCharacterData();
  }

  Future<void> saveHaveCharacter(bool haveChar) async {
    character.myStatus.have = haveChar;
    await _myStatusRepository.save(character.myStatus);

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
      await _characterRepository.refreshIcon(_selectedStyle, isSelectedIcon);

      RSLogger.d('アイコン情報をキャラ情報に反映します。');
      final styles = await _characterRepository.findStyles(character.id);
      character.refreshStyles(styles);

      return true;
    } catch (e, s) {
      RSLogger.e('アイコン更新処理でエラーが発生しました', e, s);
      return false;
    }
  }

  void refreshCharacterData() {
    _isUpdateStatus = true;
    notifyListeners();
  }
}
