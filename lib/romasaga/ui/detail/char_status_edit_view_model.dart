import 'package:flutter/foundation.dart' as foundation;
import 'package:rsapp/romasaga/common/rs_logger.dart';

import '../../model/status.dart';
import '../../data/my_status_repository.dart';

class CharStatusEditViewModel extends foundation.ChangeNotifier {
  CharStatusEditViewModel._(this._currentStatus, this._statusRepository, this._editMode);

  factory CharStatusEditViewModel.create(MyStatusForEdit status) {
    EditMode currentMode;
    if (status.isEmpty()) {
      currentMode = EditMode.manual;
    } else {
      currentMode = EditMode.each;
    }

    return CharStatusEditViewModel._(status, MyStatusRepository.create(), currentMode);
  }

  final MyStatusRepository _statusRepository;

  MyStatusForEdit _currentStatus;
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
    RSLogger.d('strを＋1します');
    _currentStatus.incrementStr();
    RSLogger.d('str=${_currentStatus.str}');
    notifyListeners();
  }

  void decrementStr() {
    RSLogger.d('strを-1します');
    _currentStatus.decrementStr();
    RSLogger.d('str=${_currentStatus.str}');
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
    _currentStatus.decrementAgi();
    notifyListeners();
  }

  void updateStatusAgi(int newVal) {
    _currentStatus.agi = newVal;
  }

  ///
  /// Int
  ///
  void incrementInt() {
    _currentStatus.incrementInt();
    notifyListeners();
  }

  void decrementInt() {
    _currentStatus.decrementInt();
    notifyListeners();
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
    _currentStatus.decrementSpirit();
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
    _currentStatus.decrementLove();
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
    _currentStatus.decrementAttr();
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
    await _statusRepository.save(_currentStatus.toMyStatus());
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
