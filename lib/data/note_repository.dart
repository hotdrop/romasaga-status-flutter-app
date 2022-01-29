import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/shared_prefs.dart';

final noteRepositoryProvider = Provider((ref) => _NoteRepository(ref.read));

class _NoteRepository {
  const _NoteRepository(this._read);

  final Reader _read;

  Future<String> find() async {
    return await _read(sharedPrefsProvider).getNote() ?? '';
  }

  Future<void> save(String note) async {
    await _read(sharedPrefsProvider).saveNote(note);
  }
}
