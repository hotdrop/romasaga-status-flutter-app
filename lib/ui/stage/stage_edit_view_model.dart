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
  int? _inputHpLimit;
  int? _inputLimit;

  bool get isExecuteSave => (_inputName != null) && (_inputHpLimit != null) && (_inputLimit != null);

  Future<void> _init() async {
    _currentStage = await _read(stageRepositoryProvider).find();
    _inputName = _currentStage.name;
    _inputHpLimit = _currentStage.hpLimit;
    _inputLimit = _currentStage.statusLimit;
    onSuccess();
  }

  void inputName(String? input) {
    _inputName = input;
    notifyListeners();
  }

  void inputHpLimit(int? input) {
    _inputHpLimit = input;
    notifyListeners();
  }

  void inputLimit(int? input) {
    _inputLimit = input;
    notifyListeners();
  }

  Future<void> save() async {
    // ここでいずれかの値がnullならプログラムバグなので落とす
    final newStage = Stage(_inputName!, _inputHpLimit!, _inputLimit!);
    await _read(stageRepositoryProvider).save(newStage);
  }
}
