import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/shared_prefs.dart';

final noteRepositoryProvider = Provider((ref) => _NoteRepository(ref));

class _NoteRepository {
  const _NoteRepository(this._ref);

  final Ref _ref;

  Future<String> find() async {
    return await _ref.read(sharedPrefsProvider).getNote() ?? '';
  }

  Future<void> save(String note) async {
    await _ref.read(sharedPrefsProvider).saveNote(note);
  }
}
