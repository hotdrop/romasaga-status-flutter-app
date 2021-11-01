import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/stage_repository.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/ui/base_view_model.dart';

final stageEditViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _StageEditViewModel(ref.read));

class _StageEditViewModel extends BaseViewModel {
  _StageEditViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late Stage _currentStage;
  Stage get currentStage => _currentStage;

  String? _inputName;
  int? _inputLimit;

  bool get isExecuteSave => (_inputName != null) && (_inputLimit != null);

  Future<void> _init() async {
    _currentStage = await _read(stageRepositoryProvider).find();
    _inputName = _currentStage.name;
    _inputLimit = _currentStage.limit;
    onSuccess();
  }

  void inputName(String? input) {
    _inputName = input;
  }

  void inputLimit(int? input) {
    _inputLimit = input;
  }

  Future<void> save() async {
    // ここでいずれかの値がnullならプログラムバグなので落とす
    final newStage = Stage(_inputName!, _inputLimit!);
    await _read(stageRepositoryProvider).save(newStage);
  }
}
