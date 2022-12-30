import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/note_repository.dart';

final noteViewModel = StateNotifierProvider.autoDispose<_NoteViewModelNotifier, AsyncValue<void>>((ref) {
  return _NoteViewModelNotifier(ref);
});

class _NoteViewModelNotifier extends StateNotifier<AsyncValue<void>> {
  _NoteViewModelNotifier(this._ref) : super(const AsyncValue.loading());

  final Ref _ref;

  Future<void> init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _ref.read(noteInputStateProvider.notifier).state = await _ref.read(noteRepositoryProvider).find();
    });
  }

  @override
  void dispose() {
    final input = _ref.read(noteInputStateProvider);
    if (input != null) {
      _ref.read(noteRepositoryProvider).save(input);
    }
    super.dispose();
  }
}

final noteInputStateProvider = StateProvider<String?>((_) => null);
