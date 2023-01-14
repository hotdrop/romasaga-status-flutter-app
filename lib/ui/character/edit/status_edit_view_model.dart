import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/models/status.dart';

part 'status_edit_view_model.g.dart';

@riverpod
class StatusEditViewModel extends _$StatusEditViewModel {
  @override
  Future<void> build(int id) async {
    // ここで_uiStateProviderを同期更新してしまうとWidgetのbuild中に更新することになるので非同期にする
    Future<void>.delayed(Duration.zero).then((value) {
      ref.read(_uiStateProvider.notifier).state = _UiState.create(id: id);
    });
  }
}

@riverpod
class StatusEditMethods extends _$StatusEditMethods {
  @override
  void build() {}

  void updateHp(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(hp: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).hp;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(hp: newVal - currentVal));
        break;
    }
  }

  void updateStr(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(str: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).str;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(str: newVal - currentVal));
        break;
    }
  }

  void updateVit(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(vit: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).vit;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(vit: newVal - currentVal));
        break;
    }
  }

  void updateDex(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(dex: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).dex;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(dex: newVal - currentVal));
        break;
    }
  }

  void updateAgi(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(agi: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).agi;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(agi: newVal - currentVal));
        break;
    }
  }

  void updateInt(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inte: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).inte;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inte: newVal - currentVal));
        break;
    }
  }

  void updateSpi(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(spi: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).spi;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(spi: newVal - currentVal));
        break;
    }
  }

  void updateLove(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(love: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).love;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(love: newVal - currentVal));
        break;
    }
  }

  void updateAttr(int newVal) {
    switch (ref.read(statusEditModeProvider)) {
      case EditMode.each:
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(attr: newVal));
        break;
      case EditMode.manual:
        final currentVal = ref.read(statusEditCurrentMyStatusProvider).attr;
        ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(attr: newVal - currentVal));
        break;
    }
  }

  void changeEditMode() {
    final currentMode = ref.read(statusEditModeProvider);
    if (currentMode == EditMode.each) {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(editMode: EditMode.manual));
    } else {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(editMode: EditMode.each));
    }
  }

  ///
  /// 更新した値を保存する
  ///
  Future<void> saveNewStatus() async {
    final currentStatus = ref.read(statusEditCurrentMyStatusProvider);
    final uiState = ref.read(_uiStateProvider);

    final newStatus = MyStatus(
      ref.read(_uiStateProvider).characterId,
      uiState.hp + currentStatus.hp,
      uiState.str + currentStatus.str,
      uiState.vit + currentStatus.vit,
      uiState.dex + currentStatus.dex,
      uiState.agi + currentStatus.agi,
      uiState.inte + currentStatus.inte,
      uiState.spi + currentStatus.spi,
      uiState.love + currentStatus.love,
      uiState.attr + currentStatus.attr,
      currentStatus.favorite,
      currentStatus.useHighLevel,
    );

    await ref.read(characterProvider.notifier).updateMyStatus(id: uiState.characterId, newStatus: newStatus);
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  _UiState(this.characterId, this.hp, this.str, this.vit, this.dex, this.agi, this.inte, this.spi, this.love, this.attr, this.editMode);

  factory _UiState.create({required int id}) {
    return _UiState(id, 0, 0, 0, 0, 0, 0, 0, 0, 0, EditMode.each);
  }

  factory _UiState.empty() {
    return _UiState(-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, EditMode.each);
  }

  final int characterId;
  final int hp;
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int inte;
  final int spi;
  final int love;
  final int attr;
  final EditMode editMode;

  _UiState copyWith({int? hp, int? str, int? vit, int? dex, int? agi, int? inte, int? spi, int? love, int? attr, EditMode? editMode}) {
    return _UiState(
      characterId,
      hp ?? this.hp,
      str ?? this.str,
      vit ?? this.vit,
      dex ?? this.dex,
      agi ?? this.agi,
      inte ?? this.inte,
      spi ?? this.spi,
      love ?? this.love,
      attr ?? this.attr,
      editMode ?? this.editMode,
    );
  }
}

// キャラの編集前ステータス情報
final statusEditCurrentMyStatusProvider = Provider<MyStatus>((ref) {
  final id = ref.watch(_uiStateProvider.select((value) => value.characterId));
  final targetCharacter = ref.watch(characterProvider.select((c) => c.firstWhere((c) => c.id == id)));
  return targetCharacter.myStatus ?? MyStatus.empty(targetCharacter.id);
});

// 編集モードの切り替え
final statusEditModeProvider = Provider<EditMode>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.editMode));
});

///
/// eachは＋➖のボタンがあって1ずつ加減算するモード
/// manualはテキストフィールドで値を自由に入力できるモード
///
/// ステータスを一度入れ終わった後は＋➖の方が使いやすいが初回入力時は60とか70をincrementで入れるのは辛すぎるので直接入力にしたかった。
/// HPなどしばらく入力してないと結構上がるのでこの2つのモードは常時変更可能。
///
enum EditMode { each, manual }
