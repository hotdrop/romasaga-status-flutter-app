import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/ui/base_view_model.dart';

final stageEditViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _StageEditViewModel(ref.read));

final stageEditInputNameStateProvider = StateProvider<String?>((_) => null);

final stageEditInputHpStateProvider = StateProvider<int?>((_) => null);

final stageEditInputStatusStateProvider = StateProvider<int?>((_) => null);

final stageEditIsExecuteSave = StateProvider<bool>((ref) {
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
    _read(stageEditInputNameStateProvider.state).state = _currentStage.name;
    _read(stageEditInputHpStateProvider.state).state = _currentStage.hpLimit;
    _read(stageEditInputHpStateProvider.state).state = _currentStage.statusLimit;
    onSuccess();
  }

  void inputName(String? input) {
    _read(stageEditInputNameStateProvider.state).state = input;
  }

  void inputHpLimit(int? input) {
    _read(stageEditInputHpStateProvider.state).state = input;
  }

  void inputLimit(int? input) {
    _read(stageEditInputStatusStateProvider.state).state = input;
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
