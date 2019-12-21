import 'package:flutter/foundation.dart' as foundation;

import '../../model/status.dart';
import '../../data/my_status_repository.dart';

import '../../common/rs_strings.dart';

class CharStatusEditViewModel extends foundation.ChangeNotifier {
  CharStatusEditViewModel._(this._currentStatus, this._statusRepository)
      : _newHp = _currentStatus.hp,
        _newStr = _currentStatus.str,
        _newVit = _currentStatus.vit,
        _newDex = _currentStatus.dex,
        _newAgi = _currentStatus.agi,
        _newInt = _currentStatus.intelligence,
        _newSpi = _currentStatus.spirit,
        _newLove = _currentStatus.love,
        _newAttr = _currentStatus.attr,
        _have = _currentStatus.have,
        _favorite = _currentStatus.favorite;

  factory CharStatusEditViewModel.create(MyStatus status) {
    return CharStatusEditViewModel._(
      status,
      MyStatusRepository.create(),
    );
  }

  final MyStatusRepository _statusRepository;
  final MyStatus _currentStatus;

  int _newHp;
  int _newStr;
  int _newVit;
  int _newDex;
  int _newAgi;
  int _newInt;
  int _newSpi;
  int _newLove;
  int _newAttr;

  bool _have;
  bool _favorite;

  void updateStatus(String statusName, int newStatus) {
    switch (statusName) {
      case RSStrings.hpName:
        _newHp = newStatus;
        break;
      case RSStrings.strName:
        _newStr = newStatus;
        break;
      case RSStrings.vitName:
        _newVit = newStatus;
        break;
      case RSStrings.dexName:
        _newDex = newStatus;
        break;
      case RSStrings.agiName:
        _newAgi = newStatus;
        break;
      case RSStrings.intName:
        _newInt = newStatus;
        break;
      case RSStrings.spiName:
        _newSpi = newStatus;
        break;
      case RSStrings.loveName:
        _newLove = newStatus;
        break;
      case RSStrings.attrName:
        _newAttr = newStatus;
        break;
    }
  }

  Future<void> saveNewStatus() async {
    final newStatus = MyStatus(
      _currentStatus.id,
      _newHp,
      _newStr,
      _newVit,
      _newDex,
      _newAgi,
      _newInt,
      _newSpi,
      _newLove,
      _newAttr,
      _have,
      _favorite,
    );
    await _statusRepository.save(newStatus);
  }
}
