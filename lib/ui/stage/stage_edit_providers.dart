import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/models/stage.dart';

part 'stage_edit_providers.g.dart';

@riverpod
class StageEditController extends _$StageEditController {
  @override
  void build() {}

  void inputName(String? newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputName: newVal ?? ''));
  }

  void inputHpLimit(int? newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputHp: newVal ?? 0));
  }

  void inputLimit(int? newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputStatusLimit: newVal ?? 0));
  }

  Future<void> save() async {
    final newStage = Stage(
      name: ref.read(_uiStateProvider).inputName,
      hpLimit: ref.read(_uiStateProvider).inputHp,
      statusLimit: ref.read(_uiStateProvider).inputStatusLimit,
    );
    await ref.read(stageProvider.notifier).save(newStage);
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) {
  return _UiState.create(
    stage: ref.read(stageProvider),
  );
});

class _UiState {
  _UiState._(this.inputName, this.inputHp, this.inputStatusLimit);

  factory _UiState.create({required Stage stage}) {
    return _UiState._(stage.name, stage.hpLimit, stage.statusLimit);
  }

  final String inputName;
  final int inputHp;
  final int inputStatusLimit;

  _UiState copyWith({String? inputName, int? inputHp, int? inputStatusLimit}) {
    return _UiState._(
      inputName ?? this.inputName,
      inputHp ?? this.inputHp,
      inputStatusLimit ?? this.inputStatusLimit,
    );
  }
}

final stageEditCurrentProvider = Provider<Stage>((ref) {
  return ref.watch(stageProvider);
});

final stageEditIsExecuteSaveProvider = Provider<bool>((ref) {
  final state = ref.watch(_uiStateProvider);
  return state.inputName.isNotEmpty && state.inputHp > 0 && state.inputStatusLimit > 0;
});
