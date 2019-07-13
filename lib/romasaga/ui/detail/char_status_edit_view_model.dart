import 'package:flutter/foundation.dart' as foundation;

import '../../model/status.dart';
import '../../data/status_repository.dart';

class CharStatusEditViewModel extends foundation.ChangeNotifier {
  CharStatusEditViewModel(this.currentStatus, {StatusRepository statusRepo})
      : _newHp = currentStatus.hp,
        _newStr = currentStatus.str,
        _newVit = currentStatus.vit,
        _newDex = currentStatus.dex,
        _newAgi = currentStatus.agi,
        _newInt = currentStatus.intelligence,
        _newSpi = currentStatus.spirit,
        _newLove = currentStatus.love,
        _newAttr = currentStatus.attr,
        _statusRepository = (statusRepo == null) ? StatusRepository() : statusRepo;

  final StatusRepository _statusRepository;
  final MyStatus currentStatus;

  int _newHp;
  int _newStr;
  int _newVit;
  int _newDex;
  int _newAgi;
  int _newInt;
  int _newSpi;
  int _newLove;
  int _newAttr;

  void updateStatus(String statusName, int newStatus) {
    switch (statusName) {
      case Status.hpName:
        _newHp = newStatus;
        break;
      case Status.strName:
        _newStr = newStatus;
        break;
      case Status.vitName:
        _newVit = newStatus;
        break;
      case Status.dexName:
        _newDex = newStatus;
        break;
      case Status.agiName:
        _newAgi = newStatus;
        break;
      case Status.intName:
        _newInt = newStatus;
        break;
      case Status.spiName:
        _newSpi = newStatus;
        break;
      case Status.loveName:
        _newLove = newStatus;
        break;
      case Status.attrName:
        _newAttr = newStatus;
        break;
    }
  }

  Future<void> saveNewStatus() async {
    final newStatus = MyStatus(
      currentStatus.charName,
      _newHp,
      _newStr,
      _newVit,
      _newDex,
      _newAgi,
      _newInt,
      _newSpi,
      _newLove,
      _newAttr,
    );
    await _statusRepository.save(newStatus);
  }
}
