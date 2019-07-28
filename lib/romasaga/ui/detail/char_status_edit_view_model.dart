import 'package:flutter/foundation.dart' as foundation;

import '../../model/status.dart';
import '../../data/my_status_repository.dart';

import '../../common/strings.dart';

class CharStatusEditViewModel extends foundation.ChangeNotifier {
  CharStatusEditViewModel(this.currentStatus, {MyStatusRepository statusRepo})
      : _newHp = currentStatus.hp,
        _newStr = currentStatus.str,
        _newVit = currentStatus.vit,
        _newDex = currentStatus.dex,
        _newAgi = currentStatus.agi,
        _newInt = currentStatus.intelligence,
        _newSpi = currentStatus.spirit,
        _newLove = currentStatus.love,
        _newAttr = currentStatus.attr,
        _have = currentStatus.have,
        _favorite = currentStatus.favorite,
        _statusRepository = (statusRepo == null) ? MyStatusRepository() : statusRepo;

  final MyStatusRepository _statusRepository;
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

  bool _have;
  bool _favorite;

  void updateStatus(String statusName, int newStatus) {
    switch (statusName) {
      case Strings.HpName:
        _newHp = newStatus;
        break;
      case Strings.StrName:
        _newStr = newStatus;
        break;
      case Strings.VitName:
        _newVit = newStatus;
        break;
      case Strings.DexName:
        _newDex = newStatus;
        break;
      case Strings.AgiName:
        _newAgi = newStatus;
        break;
      case Strings.IntName:
        _newInt = newStatus;
        break;
      case Strings.SpiName:
        _newSpi = newStatus;
        break;
      case Strings.LoveName:
        _newLove = newStatus;
        break;
      case Strings.AttrName:
        _newAttr = newStatus;
        break;
    }
  }

  Future<void> saveNewStatus() async {
    final newStatus = MyStatus(
      currentStatus.id,
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
