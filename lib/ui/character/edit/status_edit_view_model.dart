import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/models/status.dart';

///
/// ViewModelのProvider（override用）
///
final statusEditViewModel = StateNotifierProvider.autoDispose<_StatusEditViewModel, AsyncValue<void>>((ref) {
  throw UnimplementedError();
});

///
/// ViewModelの引数付きProvider
///
final statusEditFamilyViewModel = StateNotifierProvider.autoDispose.family<_StatusEditViewModel, AsyncValue<void>, MyStatus>((ref, myStatus) {
  return _StatusEditViewModel(ref.read, myStatus);
});

class _StatusEditViewModel extends StateNotifier<AsyncValue<void>> {
  _StatusEditViewModel(this._read, this._status) : super(const AsyncValue.loading());

  final Reader _read;
  final MyStatus _status;

  Future<void> init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _read(_uiStateProvider.notifier).init(_status);
    });
  }

  void updateHp(int newVal) {
    _read(_uiStateProvider.notifier).updateHp(newVal + _read(_uiStateProvider).hp);
  }

  void updateStr(int newVal) {
    _read(_uiStateProvider.notifier).updateStr(newVal + _read(_uiStateProvider).str);
  }

  void updateVit(int newVal) {
    _read(_uiStateProvider.notifier).updateVit(newVal + _read(_uiStateProvider).vit);
  }

  void updateDex(int newVal) {
    _read(_uiStateProvider.notifier).updateDex(newVal + _read(_uiStateProvider).dex);
  }

  void updateAgi(int newVal) {
    _read(_uiStateProvider.notifier).updateAgi(newVal + _read(_uiStateProvider).agi);
  }

  void updateInt(int newVal) {
    _read(_uiStateProvider.notifier).updateInt(newVal + _read(_uiStateProvider).inte);
  }

  void updateSpi(int newVal) {
    _read(_uiStateProvider.notifier).updateSpi(newVal + _read(_uiStateProvider).spi);
  }

  void updateLove(int newVal) {
    _read(_uiStateProvider.notifier).updateLove(newVal + _read(_uiStateProvider).love);
  }

  void updateAttr(int newVal) {
    _read(_uiStateProvider.notifier).updateAttr(newVal + _read(_uiStateProvider).attr);
  }

  void update(StatusType type, int newVal) {
    switch (type) {
      case StatusType.hp:
        _read(_uiStateProvider.notifier).updateHp(newVal);
        break;
      case StatusType.str:
        _read(_uiStateProvider.notifier).updateStr(newVal);
        break;
      case StatusType.vit:
        _read(_uiStateProvider.notifier).updateVit(newVal);
        break;
      case StatusType.dex:
        _read(_uiStateProvider.notifier).updateDex(newVal);
        break;
      case StatusType.agi:
        _read(_uiStateProvider.notifier).updateAgi(newVal);
        break;
      case StatusType.inte:
        _read(_uiStateProvider.notifier).updateInt(newVal);
        break;
      case StatusType.spirit:
        _read(_uiStateProvider.notifier).updateSpi(newVal);
        break;
      case StatusType.love:
        _read(_uiStateProvider.notifier).updateLove(newVal);
        break;
      case StatusType.attr:
        _read(_uiStateProvider.notifier).updateAttr(newVal);
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

  Future<void> saveNewStatus() async {
    final newStatus = MyStatus(
      _read(_uiStateProvider).id,
      _read(_uiStateProvider).hp,
      _read(_uiStateProvider).str,
      _read(_uiStateProvider).vit,
      _read(_uiStateProvider).dex,
      _read(_uiStateProvider).agi,
      _read(_uiStateProvider).inte,
      _read(_uiStateProvider).spi,
      _read(_uiStateProvider).love,
      _read(_uiStateProvider).attr,
      _status.favorite,
      _status.useHighLevel,
    );
    await _read(myStatusRepositoryProvider).save(newStatus);
  }
}

final statusEditModeStateProvider = StateProvider.autoDispose<EditMode>((_) => EditMode.each);

// 画面の状態
final _uiStateProvider = StateNotifierProvider<_UiStateNotifer, _UiState>((ref) {
  return _UiStateNotifer(_UiState.empty());
});

class _UiStateNotifer extends StateNotifier<_UiState> {
  _UiStateNotifer(_UiState state) : super(state);

  void init(MyStatus s) {
    state = _UiState(s.id, s.hp, s.str, s.vit, s.dex, s.agi, s.inte, s.spi, s.love, s.attr);
  }

  void updateHp(int newVal) {
    state = state.copyWith(hp: newVal);
  }

  void updateStr(int newVal) {
    state = state.copyWith(str: newVal);
  }

  void updateVit(int newVal) {
    state = state.copyWith(vit: newVal);
  }

  void updateDex(int newVal) {
    state = state.copyWith(dex: newVal);
  }

  void updateAgi(int newVal) {
    state = state.copyWith(agi: newVal);
  }

  void updateInt(int newVal) {
    state = state.copyWith(inte: newVal);
  }

  void updateSpi(int newVal) {
    state = state.copyWith(spi: newVal);
  }

  void updateLove(int newVal) {
    state = state.copyWith(love: newVal);
  }

  void updateAttr(int newVal) {
    state = state.copyWith(attr: newVal);
  }
}

class _UiState {
  _UiState(this.id, this.hp, this.str, this.vit, this.dex, this.agi, this.inte, this.spi, this.love, this.attr);

  factory _UiState.empty() {
    return _UiState(-1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  }

  final int id;
  final int hp;
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int inte;
  final int spi;
  final int love;
  final int attr;

  _UiState copyWith({int? id, int? hp, int? str, int? vit, int? dex, int? agi, int? inte, int? spi, int? love, int? attr}) {
    return _UiState(
      id ?? this.id,
      hp ?? this.hp,
      str ?? this.str,
      vit ?? this.vit,
      dex ?? this.dex,
      agi ?? this.agi,
      inte ?? this.inte,
      spi ?? this.spi,
      love ?? this.love,
      attr ?? this.attr,
    );
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
