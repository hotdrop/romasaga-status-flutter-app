import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/note_repository.dart';
import 'package:rsapp/ui/base_view_model.dart';

final noteViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _NoteViewModel(ref.read));

class _NoteViewModel extends BaseViewModel {
  _NoteViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late String _note;
  String get note => _note;
  String? _inputNote;

  Future<void> _init() async {
    _note = await _read(noteRepositoryProvider).find();
    onSuccess();
  }

  void input(String v) {
    _inputNote = v;
  }

  Future<void> save() async {
    // 更新されていれば保存する
    if (_note != _inputNote) {
      await _read(noteRepositoryProvider).save(_inputNote ?? '');
    }
  }

  @override
  void dispose() {
    save();
    super.dispose();
  }
}
