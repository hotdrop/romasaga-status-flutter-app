import 'package:flutter/foundation.dart' as foundation;

import '../../model/character.dart';
import '../../model/base_status.dart';

import '../../data/base_status_repository.dart';

class CharDetailViewModel extends foundation.ChangeNotifier {
  List<BaseStatus> _baseStatusList;
  BaseStatusRepository _repository;

  final Character _character;

  String _selectedRank;
  BaseStatus _selectedBaseStatus;

  CharDetailViewModel(this._character, {BaseStatusRepository repo}) {
    _repository = (repo == null) ? BaseStatusRepository() : repo;
  }

  List<BaseStatus> findBaseStatus() {
    if (_baseStatusList == null) {
      return [];
    }

    return _baseStatusList;
  }

  void load() async {
    _baseStatusList = await _repository.findAll();
    _selectedBaseStatus = _baseStatusList.first;
    notifyListeners();
  }

  BaseStatus getSelectedBaseStatus() {
    return _selectedBaseStatus;
  }

  String getSelectedBaseStatusName() {
    return _selectedBaseStatus.stageName;
  }

  void saveSelectedRank(String rank) {
    _selectedRank = rank;
    _calcStyleStatus();
  }

  String getSelectedRank() {
    return _selectedRank;
  }

  void saveSelectedBaseStatus(String stageName) {
    _selectedBaseStatus = _baseStatusList.firstWhere((s) => s.stageName == stageName);
    _calcStyleStatus();
  }

  // これstreamにしてsinkとstreamで流したほうがいいか・・？
  Style _currentStyleStatusLimit;
  static const String hpName = "ＨＰ";
  static const String strName = "腕力";
  static const String vitName = "体力";
  static const String dexName = "器用";
  static const String agiName = "素早";
  static const String intName = "知能";
  static const String spiName = "精神";
  static const String loveName = "愛";
  static const String attrName = "魅力";

  void _calcStyleStatus() {
    final style = _character.getStyle(_selectedRank);
    final addBaseStatus = _selectedBaseStatus.addLimit;

    _currentStyleStatusLimit = Style(
      _selectedRank,
      style.str + addBaseStatus,
      style.vit + addBaseStatus,
      style.dex + addBaseStatus,
      style.agi + addBaseStatus,
      style.intelligence + addBaseStatus,
      style.spirit + addBaseStatus,
      style.love + addBaseStatus,
      style.attr + addBaseStatus,
    );
    notifyListeners();
  }

  int getLimitStatus(String statusName) {
    switch (statusName) {
      case strName:
        return _currentStyleStatusLimit?.str ?? 0;
      case vitName:
        return _currentStyleStatusLimit?.vit ?? 0;
      case dexName:
        return _currentStyleStatusLimit?.dex ?? 0;
      case agiName:
        return _currentStyleStatusLimit?.agi ?? 0;
      case intName:
        return _currentStyleStatusLimit?.intelligence ?? 0;
      case spiName:
        return _currentStyleStatusLimit?.spirit ?? 0;
      case loveName:
        return _currentStyleStatusLimit?.love ?? 0;
      case attrName:
        return _currentStyleStatusLimit?.attr ?? 0;
      default:
        return 0;
    }
  }
}
