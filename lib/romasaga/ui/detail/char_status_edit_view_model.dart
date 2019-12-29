import 'package:flutter/foundation.dart' as foundation;

import '../../model/status.dart';
import '../../data/my_status_repository.dart';

class CharStatusEditViewModel extends foundation.ChangeNotifier {
  CharStatusEditViewModel._(this._currentStatus, this._statusRepository, this._editMode);

  factory CharStatusEditViewModel.create(MyStatus status) {
    EditMode currentMode;
    if (status.hp == 0 && status.sumWithoutHp() == 0) {
      currentMode = EditMode.manual;
    } else {
      currentMode = EditMode.each;
    }

    return CharStatusEditViewModel._(status, MyStatusRepository.create(), currentMode);
  }

  final MyStatusRepository _statusRepository;

  MyStatus _currentStatus;
  EditMode _editMode;
  bool get isEditEach => _editMode == EditMode.each;

  int get hp => _currentStatus.hp;
  int get str => _currentStatus.str;
  int get vit => _currentStatus.vit;
  int get dex => _currentStatus.dex;
  int get agi => _currentStatus.agi;
  int get intelligence => _currentStatus.intelligence;
  int get spirit => _currentStatus.spirit;
  int get love => _currentStatus.love;
  int get attr => _currentStatus.attr;

  ///
  /// HP
  ///
  void incrementHP() {
    _currentStatus.incrementHP();
    notifyListeners();
  }

  void decrementHP() {
    _currentStatus.decrementHP();
    notifyListeners();
  }

  void updateHP(int newVal) {
    _currentStatus.hp = newVal;
  }

  ///
  /// Str
  ///
  void incrementStr() {
    _currentStatus.incrementStr();
    notifyListeners();
  }

  void decrementStr() {
    _currentStatus.decrementStr();
    notifyListeners();
  }

  void updateStr(int newVal) {
    _currentStatus.str = newVal;
  }

  ///
  /// Vit
  ///
  void incrementVit() {
    _currentStatus.incrementVit();
    notifyListeners();
  }

  void decrementVit() {
    _currentStatus.decrementVit();
    notifyListeners();
  }

  void updateStatusVit(int newVal) {
    _currentStatus.vit = newVal;
  }

  ///
  /// Dex
  ///
  void incrementDex() {
    _currentStatus.incrementDex();
    notifyListeners();
  }

  void decrementDex() {
    _currentStatus.decrementDex();
    notifyListeners();
  }

  void updateStatusDex(int newVal) {
    _currentStatus.dex = newVal;
  }

  ///
  /// Agi
  ///
  void incrementAgi() {
    _currentStatus.incrementAgi();
    notifyListeners();
  }

  void decrementAgi() {
    _currentStatus.incrementAgi();
    notifyListeners();
  }

  void updateStatusAgi(int newVal) {
    _currentStatus.agi = newVal;
  }

  void updateStatusInt(int newVal) {
    _currentStatus.intelligence = newVal;
  }

  ///
  /// Spirit
  ///
  void incrementSpirit() {
    _currentStatus.incrementSpirit();
    notifyListeners();
  }

  void decrementSpirit() {
    _currentStatus.incrementSpirit();
    notifyListeners();
  }

  void updateStatusSpi(int newVal) {
    _currentStatus.spirit = newVal;
  }

  ///
  /// Love
  ///
  void incrementLove() {
    _currentStatus.incrementLove();
    notifyListeners();
  }

  void decrementLove() {
    _currentStatus.incrementLove();
    notifyListeners();
  }

  void updateLove(int newVal) {
    _currentStatus.love = newVal;
  }

  ///
  /// Attr
  ///
  void incrementAttr() {
    _currentStatus.incrementAttr();
    notifyListeners();
  }

  void decrementAttr() {
    _currentStatus.incrementAttr();
    notifyListeners();
  }

  void updateAttr(int newVal) {
    _currentStatus.attr = newVal;
  }

  void changeEditMode() {
    if (_editMode == EditMode.each) {
      _editMode = EditMode.manual;
    } else {
      _editMode = EditMode.each;
    }
    notifyListeners();
  }

  Future<void> saveNewStatus() async {
    await _statusRepository.save(_currentStatus);
  }
}

///
/// eachは＋➖のボタンがあって1ずつ加減算するモード
/// manualはテキストフィールドで値を自由に入力できるモード
///
/// ステータスを一度入れ終わった後は＋➖の方が使いやすいが初回入力時は60とか70をincrementで入れるのは辛すぎるので直接入力にしたかった。
/// HPなどしばらく入力してないと結構上がるのでこの2つのモードは常時変更可能。
///
enum EditMode { each, manual }
