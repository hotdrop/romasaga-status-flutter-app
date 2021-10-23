import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/my_status_repository.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/romasaga/ui/change_notifier_view_model.dart';

class CharStatusEditViewModel extends ChangeNotifierViewModel {
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

  void increment(StatusType type) {
    _currentStatus.increment(type);
    notifyListeners();
  }

  void decrement(StatusType type) {
    _currentStatus.decrement(type);
    notifyListeners();
  }

  void update(StatusType type, int newVal) {
    _currentStatus.update(type, newVal);
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
    try {
      await _statusRepository.save(_currentStatus.toMyStatus());
    } catch (e, s) {
      await RSLogger.e('キャラステータス編集画面で保存に失敗しました。', e, s);
    }
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
