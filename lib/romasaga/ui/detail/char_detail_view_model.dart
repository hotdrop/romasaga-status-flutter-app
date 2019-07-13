import 'package:flutter/foundation.dart' as foundation;

import '../../model/character.dart';
import '../../model/status.dart';
import '../../model/stage.dart';

import '../../data/status_repository.dart';
import '../../data/stage_repository.dart';

class CharDetailViewModel extends foundation.ChangeNotifier {
  CharDetailViewModel(this.character, {StageRepository stageRepo, StatusRepository statusRepo})
      : _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo,
        _statusRepository = (statusRepo == null) ? StatusRepository() : statusRepo,
        _selectedRank = character.getStyleRanks().first;

  final StageRepository _stageRepository;
  final StatusRepository _statusRepository;
  final Character character;

  MyStatus _myStatus;
  List<Stage> _stages;

  String _selectedRank;
  Stage _selectedStage;

  List<Stage> findStages() {
    if (_stages == null) {
      return [];
    }

    return _stages;
  }

  MyStatus findMyStatus() {
    if (_myStatus == null) {
      return MyStatus.empty(character.name);
    }

    return _myStatus;
  }

  void load() async {
    _stages = await _stageRepository.findAll();
    _myStatus = await _statusRepository.find(character.name);

    _selectedStage = _stages.first;
    _calcStatusUpperLimits();
  }

  void refreshStatus() async {
    _myStatus = await _statusRepository.find(character.name);
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
      style.str + _selectedStage.statusUpperLimit,
      style.vit + _selectedStage.statusUpperLimit,
      style.dex + _selectedStage.statusUpperLimit,
      style.agi + _selectedStage.statusUpperLimit,
      style.intelligence + _selectedStage.statusUpperLimit,
      style.spirit + _selectedStage.statusUpperLimit,
      style.love + _selectedStage.statusUpperLimit,
      style.attr + _selectedStage.statusUpperLimit,
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
}
