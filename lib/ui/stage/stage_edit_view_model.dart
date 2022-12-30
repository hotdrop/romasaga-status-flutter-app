import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/stage.dart';

final stageEditViewModel = StateNotifierProvider.autoDispose<_StageEditViewModel, AsyncValue<void>>((ref) {
  return _StageEditViewModel(ref);
});

class _StageEditViewModel extends StateNotifier<AsyncValue<void>> {
  _StageEditViewModel(this._ref) : super(const AsyncValue.loading());

  final Ref _ref;

  Future<void> init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => _ref.read(_uiStateProvider.notifier).refresh());
  }

  void inputName(String? newVal) {
    _ref.read(_uiStateProvider.notifier).inputName(newVal);
  }

  void inputHpLimit(int? newVal) {
    _ref.read(_uiStateProvider.notifier).inputHpLimit(newVal);
  }

  void inputLimit(int? newVal) {
    _ref.read(_uiStateProvider.notifier).inputLimit(newVal);
  }

  Future<void> save() async {
    final newStage = Stage(
      name: _ref.read(_uiStateProvider).inputName,
      hpLimit: _ref.read(_uiStateProvider).inputHp,
      statusLimit: _ref.read(_uiStateProvider).inputStatusLimit,
    );
    await _ref.read(stageRepositoryProvider).save(newStage);
  }
}

final _uiStateProvider = StateNotifierProvider<_UiStateNotifier, _UiState>((ref) {
  return _UiStateNotifier(ref, _UiState.empty());
});

class _UiStateNotifier extends StateNotifier<_UiState> {
  _UiStateNotifier(this._ref, _UiState state) : super(state);

  final Ref _ref;

  Future<void> refresh() async {
    final currentStage = await _ref.read(stageRepositoryProvider).find();
    state = _UiState(currentStage, currentStage.name, currentStage.hpLimit, currentStage.statusLimit);
  }

  void inputName(String? newVal) {
    state = state.copyWith(inputName: newVal ?? '');
  }

  void inputHpLimit(int? newVal) {
    state = state.copyWith(inputHp: newVal ?? 0);
  }

  void inputLimit(int? newVal) {
    state = state.copyWith(inputStatusLimit: newVal ?? 0);
  }
}

class _UiState {
  _UiState(this.currentStage, this.inputName, this.inputHp, this.inputStatusLimit);

  factory _UiState.empty() {
    final emptyStage = Stage.empty();
    return _UiState(emptyStage, emptyStage.name, emptyStage.hpLimit, emptyStage.statusLimit);
  }

  final Stage currentStage;
  final String inputName;
  final int inputHp;
  final int inputStatusLimit;

  _UiState copyWith({String? inputName, int? inputHp, int? inputStatusLimit}) {
    return _UiState(
      currentStage,
      inputName ?? this.inputName,
      inputHp ?? this.inputHp,
      inputStatusLimit ?? this.inputStatusLimit,
    );
  }
}

final stageEditCurrentProvider = Provider<Stage>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.currentStage));
});

final stageEditIsExecuteSaveProvider = Provider<bool>((ref) {
  final state = ref.watch(_uiStateProvider);
  return state.inputName.isNotEmpty && state.inputHp > 0 && state.inputStatusLimit > 0;
});
