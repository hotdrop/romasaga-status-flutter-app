import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/data/note_repository.dart';

part 'note_providers.g.dart';

@riverpod
class NoteController extends _$NoteController {
  @override
  Future<void> build() async {
    final currentNote = await ref.read(noteRepositoryProvider).find();

    ref.onDispose(() {
      ref.read(_uiStateProvider).dispose();
    });
    final controller = TextEditingController();
    controller.addListener(() {
      ref.read(_inputNoteStateProvider.notifier).state = controller.text;
    });
    controller.text = currentNote;

    ref.read(_uiStateProvider.notifier).state = _UiState.create(currentNote, controller);
  }

  void clear() {
    ref.read(_uiStateProvider).clear();
  }

  Future<void> save() async {
    final inputValue = ref.read(_uiStateProvider).inputValue;
    await ref.read(noteRepositoryProvider).save(inputValue);
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(currentNote: inputValue));
  }
}

final _uiStateProvider = StateProvider((ref) => _UiState.empty());

class _UiState {
  _UiState._({required this.currentNote, required this.noteController});

  factory _UiState.create(String note, TextEditingController controller) {
    return _UiState._(currentNote: note, noteController: controller);
  }

  factory _UiState.empty() {
    return _UiState._(currentNote: '', noteController: TextEditingController());
  }

  final String currentNote;
  final TextEditingController noteController;

  String get inputValue => noteController.text;

  void clear() {
    noteController.text = currentNote;
  }

  void dispose() {
    noteController.dispose();
  }

  _UiState copyWith({String? currentNote}) {
    return _UiState._(
      currentNote: currentNote ?? this.currentNote,
      noteController: noteController,
    );
  }
}

// 保存した簡易メモ
final noteProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.currentNote));
});

// TextFieldの入力値をControllerで持っているので「ノートが更新されているか？」のwatchを有効にするため入力値のStateProviderを用意する
final _inputNoteStateProvider = StateProvider<String>((_) => '');

// ノートが更新されているか？
final noteIsUpdateCurrentNoteProvider = Provider<bool>((ref) {
  final currentNote = ref.watch(_uiStateProvider.select((value) => value.currentNote));
  final inputNote = ref.watch(_inputNoteStateProvider);
  return currentNote != inputNote;
});

// テキストフィールド
final noteTextEditControllerProvider = Provider((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.noteController));
});
