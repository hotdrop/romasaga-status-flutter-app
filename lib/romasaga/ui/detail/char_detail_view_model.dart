import 'package:flutter/foundation.dart' as foundation;

import '../../model/character.dart';
import '../../model/style.dart';
import '../../model/status.dart';
import '../../model/stage.dart';

import '../../data/character_repository.dart';
import '../../data/my_status_repository.dart';
import '../../data/stage_repository.dart';

import '../../common/strings.dart';
import '../../common/saga_logger.dart';

class CharDetailViewModel extends foundation.ChangeNotifier {
  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;
  final MyStatusRepository _myStatusRepository;

  final Character character;

  CharDetailViewModel(this.character, {CharacterRepository characterRepo, StageRepository stageRepo, MyStatusRepository statusRepo})
      : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo,
        _myStatusRepository = (statusRepo == null) ? MyStatusRepository() : statusRepo;

  List<Stage> _stages;

  Style _selectedStyle;
  Stage _selectedStage;

  bool isLoading = true;

  void load() async {
    SagaLogger.d("ロードします。");
    _stages = await _stageRepository.findAll();
    _selectedStage = _stages.first;

    if (character.styles.isEmpty) {
      SagaLogger.d("キャラクターのスタイルが未取得なので取得します。");
      final styles = await _characterRepository.findStyles(character.id);
      character.addStyles(styles);
    }

    _selectedStyle = character.getSelectedStyle();

    isLoading = false;
    notifyListeners();
  }

  String getSelectedIconFileName() {
    return _selectedStyle.iconFileName;
  }

  MyStatus getMyStatus() {
    return character.myStatus;
  }

  String getSelectedRank() {
    return character.selectedStyleRank;
  }

  void saveSelectedRank(String rank) {
    _selectedStyle = character.getStyle(rank);
    notifyListeners();
  }

  String getSelectedStyleTitle() {
    return _selectedStyle.title;
  }

  List<String> getAllRanks() {
    final ranks = character.styles.map((style) => style.rank).toList();
    return ranks..sort((s, t) => s.compareTo(t));
  }

  Style getStyle(String rank) {
    return character.getStyle(rank);
  }

  List<Stage> findStages() {
    return _stages;
  }

  String getSelectedStageName() {
    return _selectedStage?.name ?? null;
  }

  void saveSelectedStage(String stageName) {
    _selectedStage = _stages.firstWhere((s) => s.name == stageName);
    notifyListeners();
  }

  void refreshStatus() async {
    character.myStatus = await _myStatusRepository.find(character.id);
    notifyListeners();
  }

  int addUpperLimit(int status) => status + _selectedStage.limit;

  int getStatusUpperLimit(String statusName) {
    var targetStatus;
    switch (statusName) {
      case Strings.StrName:
        targetStatus = _selectedStyle?.str;
        break;
      case Strings.VitName:
        targetStatus = _selectedStyle?.vit;
        break;
      case Strings.DexName:
        targetStatus = _selectedStyle?.dex;
        break;
      case Strings.AgiName:
        targetStatus = _selectedStyle?.agi;
        break;
      case Strings.IntName:
        targetStatus = _selectedStyle?.intelligence;
        break;
      case Strings.SpiName:
        targetStatus = _selectedStyle?.spirit;
        break;
      case Strings.LoveName:
        targetStatus = _selectedStyle?.love;
        break;
      case Strings.AttrName:
        targetStatus = _selectedStyle?.attr;
        break;
      default:
        targetStatus = 0;
        break;
    }

    if (targetStatus == null) {
      return 0;
    }
    return targetStatus + _selectedStage.limit;
  }

  void saveHaveCharacter(bool haveChar) async {
    SagaLogger.d("このキャラの保持を $haveChar にします。");
    character.myStatus.have = haveChar;
    await _myStatusRepository.save(character.myStatus);
    notifyListeners();
  }

  void saveFavorite(bool favorite) async {
    SagaLogger.d("お気に入りを $favorite にします。");
    character.myStatus.favorite = favorite;
    await _myStatusRepository.save(character.myStatus);
    notifyListeners();
  }
}
