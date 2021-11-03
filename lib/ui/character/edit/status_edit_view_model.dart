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

  void increment(StatusType type) {
    switch (type) {
      case StatusType.hp:
        editHp++;
        break;
      case StatusType.str:
        editStr++;
        break;
      case StatusType.vit:
        editVit++;
        break;
      case StatusType.dex:
        editDex++;
        break;
      case StatusType.agi:
        editAgi++;
        break;
      case StatusType.inte:
        editInt++;
        break;
      case StatusType.spirit:
        editSpi++;
        break;
      case StatusType.love:
        editLove++;
        break;
      case StatusType.attr:
        editAttr++;
        break;
    }
    notifyListeners();
  }

  void decrement(StatusType type) {
    switch (type) {
      case StatusType.hp:
        (editHp > 0) ? editHp-- : editHp = 0;
        break;
      case StatusType.str:
        (editStr > 0) ? editStr-- : editStr = 0;
        break;
      case StatusType.vit:
        (editVit > 0) ? editVit-- : editVit = 0;
        break;
      case StatusType.dex:
        (editDex > 0) ? editDex-- : editDex = 0;
        break;
      case StatusType.agi:
        (editAgi > 0) ? editAgi-- : editAgi = 0;
        break;
      case StatusType.inte:
        (editInt > 0) ? editInt-- : editInt = 0;
        break;
      case StatusType.spirit:
        (editSpi > 0) ? editSpi-- : editSpi = 0;
        break;
      case StatusType.love:
        (editLove > 0) ? editLove-- : editLove = 0;
        break;
      case StatusType.attr:
        (editAttr > 0) ? editAttr-- : editAttr = 0;
        break;
    }
    notifyListeners();
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
    final newStatus = MyStatus(currentStatus.id, editHp, editStr, editVit, editDex, editAgi, editInt, editSpi, editLove, editAttr, currentStatus.favorite);
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
