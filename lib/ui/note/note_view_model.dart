import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/note_repository.dart';

final noteStateProvider = StateNotifierProvider.autoDispose<_NoteStateNotifier, AsyncValue<String>>((ref) {
  return _NoteStateNotifier(ref.read);
});

class _NoteStateNotifier extends StateNotifier<AsyncValue<String>> {
  _NoteStateNotifier(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final note = await _read(noteRepositoryProvider).find();
      _read(noteInputStateProvider.notifier).state = note;
      return note;
    });
  }

  @override
  void dispose() {
    final input = _read(noteInputStateProvider);
    if (input != null) {
      _read(noteRepositoryProvider).save(input);
    }
    super.dispose();
  }
}

final noteInputStateProvider = StateProvider<String?>((_) => null);
