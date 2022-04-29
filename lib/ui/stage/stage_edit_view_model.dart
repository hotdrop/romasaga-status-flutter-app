import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/ui/base_view_model.dart';

// TODO ここAsyncValueで良い
final stageEditViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _StageEditViewModel(ref.read));

final stageEditInputNameStateProvider = StateProvider<String?>((ref) => null);

final stageEditInputHpStateProvider = StateProvider<int?>((_) => null);

final stageEditInputStatusStateProvider = StateProvider<int?>((_) => null);

final stageEditIsExecuteSaveStateProvider = StateProvider<bool>((ref) {
  final inputName = ref.watch(stageEditInputNameStateProvider);
  final inputHp = ref.watch(stageEditInputHpStateProvider);
  final inputStatus = ref.watch(stageEditInputStatusStateProvider);

  return inputName != null && inputName.isNotEmpty && inputHp != null && inputHp > 0 && inputStatus != null;
});

class _StageEditViewModel extends BaseViewModel {
  _StageEditViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late Stage _currentStage;
  Stage get currentStage => _currentStage;

  Future<void> _init() async {
    _currentStage = await _read(stageRepositoryProvider).find();

    _read(stageEditInputNameStateProvider.notifier).state = _currentStage.name;
    _read(stageEditInputHpStateProvider.notifier).state = _currentStage.hpLimit;
    _read(stageEditInputStatusStateProvider.notifier).state = _currentStage.statusLimit;
    onSuccess();
  }

  void inputName(String? input) {
    _read(stageEditInputNameStateProvider.notifier).state = input;
  }

  void inputHpLimit(int? input) {
    _read(stageEditInputHpStateProvider.notifier).state = input;
  }

  void inputLimit(int? input) {
    _read(stageEditInputStatusStateProvider.notifier).state = input;
  }

  Future<void> save() async {
    // ここでいずれかの値がnullならプログラムバグなので落とす
    final newStage = Stage(
      name: _read(stageEditInputNameStateProvider)!,
      hpLimit: _read(stageEditInputHpStateProvider)!,
      statusLimit: _read(stageEditInputStatusStateProvider)!,
    );
    await _read(stageRepositoryProvider).save(newStage);
  }
}
