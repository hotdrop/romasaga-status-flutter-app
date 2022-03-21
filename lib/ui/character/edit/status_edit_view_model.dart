import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/ui/base_view_model.dart';

final statusEditViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _StatusEditViewModel(ref.read));

class _StatusEditViewModel extends BaseViewModel {
  _StatusEditViewModel(this._read);

  final Reader _read;

  EditMode _editMode = EditMode.each;
  bool get isEditEach => _editMode == EditMode.each;

  late MyStatus _status;
  int editHp = 0;
  int editStr = 0;
  int editVit = 0;
  int editDex = 0;
  int editAgi = 0;
  int editInt = 0;
  int editSpi = 0;
  int editLove = 0;
  int editAttr = 0;

  void init(MyStatus status) {
    _status = status;
    editHp = status.hp;
    editStr = status.str;
    editVit = status.vit;
    editDex = status.dex;
    editAgi = status.agi;
    editInt = status.inte;
    editSpi = status.spi;
    editLove = status.love;
    editAttr = status.attr;
    onSuccess();
  }

  void updateHp(int newVal) {
    editHp = _status.hp + newVal;
  }

  void updateStr(int newVal) {
    editStr = _status.str + newVal;
  }

  void updateVit(int newVal) {
    editVit = _status.vit + newVal;
  }

  void updateDex(int newVal) {
    editDex = _status.dex + newVal;
  }

  void updateAgi(int newVal) {
    editAgi = _status.agi + newVal;
  }

  void updateInt(int newVal) {
    editInt = _status.inte + newVal;
  }

  void updateSpi(int newVal) {
    editSpi = _status.spi + newVal;
  }

  void updateLove(int newVal) {
    editLove = _status.love + newVal;
  }

  void updateAttr(int newVal) {
    editAttr = _status.attr + newVal;
  }

  void update(StatusType type, int newVal) {
    switch (type) {
      case StatusType.hp:
        editHp = newVal;
        break;
      case StatusType.str:
        editStr = newVal;
        break;
      case StatusType.vit:
        editVit = newVal;
        break;
      case StatusType.dex:
        editDex = newVal;
        break;
      case StatusType.agi:
        editAgi = newVal;
        break;
      case StatusType.inte:
        editInt = newVal;
        break;
      case StatusType.spirit:
        editSpi = newVal;
        break;
      case StatusType.love:
        editLove = newVal;
        break;
      case StatusType.attr:
        editAttr = newVal;
        break;
    }
  }

  void changeEditMode() {
    if (_editMode == EditMode.each) {
      _editMode = EditMode.manual;
    } else {
      _editMode = EditMode.each;
    }
    notifyListeners();
  }

  Future<void> saveNewStatus(MyStatus currentStatus) async {
    final newStatus = MyStatus(
      currentStatus.id,
      editHp,
      editStr,
      editVit,
      editDex,
      editAgi,
      editInt,
      editSpi,
      editLove,
      editAttr,
      currentStatus.favorite,
      currentStatus.useHighLevel,
    );
    await _read(myStatusRepositoryProvider).save(newStatus);
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
