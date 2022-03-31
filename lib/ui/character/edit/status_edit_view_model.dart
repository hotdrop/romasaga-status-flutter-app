import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/ui/base_view_model.dart';

final statusEditViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _StatusEditViewModel(ref.read));

final statusEditMyStatusStateProvider = StateProvider<MyStatus?>((_) => null);

final statusEditModeStateProvider = StateProvider<EditMode>((_) => EditMode.each);

// 入力用のStateProvider
final statusEditHpStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.hp;
});

final statusEditStrStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.str;
});

final statusEditVitStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.vit;
});

final statusEditDexStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.dex;
});

final statusEditAgiStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.agi;
});

final statusEditIntStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.inte;
});

final statusEditSpiStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.spi;
});

final statusEditLoveStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.love;
});

final statusEditAttrStateProvider = StateProvider<int>((ref) {
  final myStatus = ref.watch(statusEditMyStatusStateProvider);
  return myStatus!.attr;
});

class _StatusEditViewModel extends BaseViewModel {
  _StatusEditViewModel(this._read);

  final Reader _read;

  void init(MyStatus status) {
    _read(statusEditMyStatusStateProvider.notifier).state = status;
    onSuccess();
  }

  void updateHp(int newVal) {
    _read(statusEditHpStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.hp + newVal;
  }

  void updateStr(int newVal) {
    _read(statusEditStrStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.str + newVal;
  }

  void updateVit(int newVal) {
    _read(statusEditVitStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.vit + newVal;
  }

  void updateDex(int newVal) {
    _read(statusEditDexStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.dex + newVal;
  }

  void updateAgi(int newVal) {
    _read(statusEditAgiStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.agi + newVal;
  }

  void updateInt(int newVal) {
    _read(statusEditIntStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.inte + newVal;
  }

  void updateSpi(int newVal) {
    _read(statusEditSpiStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.spi + newVal;
  }

  void updateLove(int newVal) {
    _read(statusEditLoveStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.love + newVal;
  }

  void updateAttr(int newVal) {
    _read(statusEditAttrStateProvider.notifier).state = _read(statusEditMyStatusStateProvider)!.attr + newVal;
  }

  void update(StatusType type, int newVal) {
    switch (type) {
      case StatusType.hp:
        _read(statusEditHpStateProvider.notifier).state = newVal;
        break;
      case StatusType.str:
        _read(statusEditStrStateProvider.notifier).state = newVal;
        break;
      case StatusType.vit:
        _read(statusEditVitStateProvider.notifier).state = newVal;
        break;
      case StatusType.dex:
        _read(statusEditDexStateProvider.notifier).state = newVal;
        break;
      case StatusType.agi:
        _read(statusEditAgiStateProvider.notifier).state = newVal;
        break;
      case StatusType.inte:
        _read(statusEditIntStateProvider.notifier).state = newVal;
        break;
      case StatusType.spirit:
        _read(statusEditSpiStateProvider.notifier).state = newVal;
        break;
      case StatusType.love:
        _read(statusEditLoveStateProvider.notifier).state = newVal;
        break;
      case StatusType.attr:
        _read(statusEditAttrStateProvider.notifier).state = newVal;
        break;
    }
  }

  void changeEditMode() {
    final currentMode = _read(statusEditModeStateProvider);
    if (currentMode == EditMode.each) {
      _read(statusEditModeStateProvider.notifier).state = EditMode.manual;
    } else {
      _read(statusEditModeStateProvider.notifier).state = EditMode.each;
    }
  }

  Future<void> saveNewStatus(MyStatus currentStatus) async {
    final newStatus = MyStatus(
      currentStatus.id,
      _read(statusEditHpStateProvider),
      _read(statusEditStrStateProvider),
      _read(statusEditVitStateProvider),
      _read(statusEditDexStateProvider),
      _read(statusEditAgiStateProvider),
      _read(statusEditIntStateProvider),
      _read(statusEditSpiStateProvider),
      _read(statusEditLoveStateProvider),
      _read(statusEditAttrStateProvider),
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
