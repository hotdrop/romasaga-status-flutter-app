import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/note_repository.dart';

final noteViewModel = StateNotifierProvider.autoDispose<_NoteViewModelNotifier, AsyncValue<void>>((ref) {
  return _NoteViewModelNotifier(ref.read);
});

class _NoteViewModelNotifier extends StateNotifier<AsyncValue<void>> {
  _NoteViewModelNotifier(this._read) : super(const AsyncValue.loading());

  final Reader _read;

  Future<void> init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _read(noteInputStateProvider.notifier).state = await _read(noteRepositoryProvider).find();
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
