import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/data/note_repository.dart';

part 'note_providers.g.dart';

@riverpod
class NoteController extends _$NoteController {
  @override
  Future<void> build() async {
    final currentNote = await ref.read(noteRepositoryProvider).find();

    ref.onDispose(() async {
      final input = ref.read(_uiStateProvider).inputNote;
      await ref.read(noteRepositoryProvider).save(input);
    });

    ref.read(_uiStateProvider.notifier).state = _UiState.create(currentNote);
  }

  void input(String inputVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputNote: inputVal));
  }
}

final _uiStateProvider = StateProvider((ref) => _UiState.empty());

class _UiState {
  _UiState._({required this.currentNote, required this.inputNote});

  factory _UiState.create(String note) {
    return _UiState._(currentNote: note, inputNote: note);
  }

  factory _UiState.empty() {
    return _UiState._(currentNote: '', inputNote: '');
  }

  final String currentNote;
  final String inputNote;

  _UiState copyWith({String? inputNote}) {
    return _UiState._(
      currentNote: currentNote,
      inputNote: inputNote ?? this.inputNote,
    );
  }
}

final noteProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.currentNote));
});
