import 'package:flutter/foundation.dart' as foundation;

import '../../model/character.dart';
import '../../model/stage.dart';

import '../../data/stage_repository.dart';

class CharDetailViewModel extends foundation.ChangeNotifier {
  final BaseStatusRepository _repository;
  final Character _character;

  List<Stage> _stages;

  String _selectedRank;
  Stage _selectedStage;

  CharDetailViewModel(this._character, {BaseStatusRepository repo}) : _repository = (repo == null) ? BaseStatusRepository() : repo;

  List<Stage> findStages() {
    if (_stages == null) {
      return [];
    }

    return _stages;
  }

  void load() async {
    _stages = await _repository.findAll();
    _selectedStage = _stages.first;
    notifyListeners();
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
  static const String hpName = "ＨＰ";
  static const String strName = "腕力";
  static const String vitName = "体力";
  static const String dexName = "器用";
  static const String agiName = "素早";
  static const String intName = "知能";
  static const String spiName = "精神";
  static const String loveName = "愛";
  static const String attrName = "魅力";

  void _calcStatusUpperLimits() {
    final style = _character.getStyle(_selectedRank);

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
      case strName:
        return _statusUpperLimit?.str ?? 0;
      case vitName:
        return _statusUpperLimit?.vit ?? 0;
      case dexName:
        return _statusUpperLimit?.dex ?? 0;
      case agiName:
        return _statusUpperLimit?.agi ?? 0;
      case intName:
        return _statusUpperLimit?.intelligence ?? 0;
      case spiName:
        return _statusUpperLimit?.spirit ?? 0;
      case loveName:
        return _statusUpperLimit?.love ?? 0;
      case attrName:
        return _statusUpperLimit?.attr ?? 0;
      default:
        return 0;
    }
  }
}
