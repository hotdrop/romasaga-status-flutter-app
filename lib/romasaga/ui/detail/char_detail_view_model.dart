import 'package:flutter/foundation.dart' as foundation;

import '../../model/character.dart';
import '../../model/status.dart';
import '../../model/stage.dart';

import '../../data/status_repository.dart';
import '../../data/stage_repository.dart';

import '../../common/saga_logger.dart';

class CharDetailViewModel extends foundation.ChangeNotifier {
  CharDetailViewModel(this.character, {StageRepository stageRepo, StatusRepository statusRepo})
      : _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo,
        _statusRepository = (statusRepo == null) ? StatusRepository() : statusRepo,
        _selectedRank = character.getStyleRanks().first;

  final StageRepository _stageRepository;
  final StatusRepository _statusRepository;
  final Character character;

  List<Stage> _stages;

  String _selectedRank;
  Stage _selectedStage;

  List<Stage> findStages() {
    if (_stages == null) {
      return [];
    }

    return _stages;
  }

  MyStatus getMyStatus() {
    return character.myStatus;
  }

  void load() async {
    _stages = await _stageRepository.findAll();
    _selectedStage = _stages.first;
    _calcStatusUpperLimits();
  }

  void refreshStatus() async {
    character.myStatus = await _statusRepository.find(character.name);
    _calcStatusUpperLimits();
  }

  Stage getSelectedBaseStatus() {
    return _selectedStage;
  }

  String getSelectedBaseStatusName() {
    return _selectedStage?.name ?? null;
  }

  void saveSelectedRank(String rank) {
    _selectedRank = rank;
    _calcStatusUpperLimits();
  }

  String getSelectedRank() {
    return _selectedRank;
  }

  void saveSelectedStage(String stageName) {
    _selectedStage = _stages.firstWhere((s) => s.name == stageName);
    _calcStatusUpperLimits();
  }

  // これstreamにしてsinkとstreamで流したほうがいいか・・？
  Style _statusUpperLimit;

  void _calcStatusUpperLimits() {
    final style = character.getStyle(_selectedRank);

    _statusUpperLimit = Style(
      _selectedRank,
      style.str + _selectedStage.limit,
      style.vit + _selectedStage.limit,
      style.dex + _selectedStage.limit,
      style.agi + _selectedStage.limit,
      style.intelligence + _selectedStage.limit,
      style.spirit + _selectedStage.limit,
      style.love + _selectedStage.limit,
      style.attr + _selectedStage.limit,
    );
    notifyListeners();
  }

  int getStatusUpperLimit(String statusName) {
    switch (statusName) {
      case Status.strName:
        return _statusUpperLimit?.str ?? 0;
      case Status.vitName:
        return _statusUpperLimit?.vit ?? 0;
      case Status.dexName:
        return _statusUpperLimit?.dex ?? 0;
      case Status.agiName:
        return _statusUpperLimit?.agi ?? 0;
      case Status.intName:
        return _statusUpperLimit?.intelligence ?? 0;
      case Status.spiName:
        return _statusUpperLimit?.spirit ?? 0;
      case Status.loveName:
        return _statusUpperLimit?.love ?? 0;
      case Status.attrName:
        return _statusUpperLimit?.attr ?? 0;
      default:
        return 0;
    }
  }

  void saveHaveCharacter(bool haveChar) async {
    SagaLogger.d("このキャラの保持を $haveChar にします。");
    character.myStatus.have = haveChar;
    await _statusRepository.save(character.myStatus);
    notifyListeners();
  }

  void saveFavorite(bool favorite) async {
    SagaLogger.d("お気に入りを $favorite にします。");
    character.myStatus.favorite = favorite;
    await _statusRepository.save(character.myStatus);
    notifyListeners();
  }
}
