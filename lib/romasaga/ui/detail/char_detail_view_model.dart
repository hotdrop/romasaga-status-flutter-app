import 'package:flutter/foundation.dart' as foundation;
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/style.dart';
import 'package:rsapp/romasaga/model/stage.dart';
import 'package:rsapp/romasaga/data/character_repository.dart';
import 'package:rsapp/romasaga/data/my_status_repository.dart';
import 'package:rsapp/romasaga/data/stage_repository.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

class CharDetailViewModel extends foundation.ChangeNotifier {
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

  _PageState _pageState = _PageState.loading;
  bool get isLoading => _pageState == _PageState.loading;
  bool get isSuccess => _pageState == _PageState.success;
  bool get isError => _pageState == _PageState.error;

  final Character character;
  bool get haveAttribute => character.attributes?.isNotEmpty ?? false;
  int get myTotalStatus => character.myStatus.sumWithoutHp();

  List<Stage> _stages;
  List<Stage> get stages => _stages ?? [];

  Style _selectedStyle;
  Stage _selectedStage;
  String get selectedIconFilePath => _selectedStyle?.iconFilePath ?? 'default';
  String get selectedStyleTitle => _selectedStyle?.title ?? '';

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    RSLogger.d('キャラ詳細情報をロードします。');
    _pageState = _PageState.loading;
    notifyListeners();

    try {
      _stages = await _stageRepository.findAll();
      _selectedStage = _stages.first;

      if (character.styles.isEmpty) {
        RSLogger.d('キャラクターのスタイルが未取得なので取得します。id=${character.id}');
        final styles = await _characterRepository.findStyles(character.id);
        RSLogger.d('キャラクターのスタイルを取得しました。件数=${styles.length}');
        character.addStyles(styles);
      }

      _selectedStyle = character.selectedStyle;

      _pageState = _PageState.success;
      notifyListeners();
    } catch (e) {
      RSLogger.e('${character.name}のロード時にエラーが発生しました。', e);
      _pageState = _PageState.error;
      notifyListeners();
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
    notifyListeners();
  }

  Future<void> saveCurrentSelectStyle() async {
    RSLogger.d('表示ランクを ${_selectedStyle.rank} にします。');
    character.selectedStyleRank = _selectedStyle.rank;
    character.selectedIconFilePath = _selectedStyle.iconFilePath;
    await _characterRepository.saveSelectedRank(character.id, _selectedStyle.rank, _selectedStyle.iconFilePath);
  }

  Future<void> saveFavorite(bool favorite) async {
    character.myStatus.favorite = favorite;
    await _myStatusRepository.save(character.myStatus);
    notifyListeners();
  }

  Future<void> saveStatusUpEvent(int id, bool statusUpEvent) async {
    character.statusUpEvent = statusUpEvent;
    await _characterRepository.saveStatusUpEvent(id, statusUpEvent);
    notifyListeners();
  }

  Future<void> saveHaveCharacter(bool haveChar) async {
    character.myStatus.have = haveChar;
    await _myStatusRepository.save(character.myStatus);
    notifyListeners();
  }
}

enum _PageState { loading, success, error }
