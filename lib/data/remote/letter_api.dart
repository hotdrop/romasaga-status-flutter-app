import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/json/letter_json.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/service/rs_service.dart';

final letterApiProvider = Provider((ref) => _LetterApi(ref.read));

class _LetterApi {
  const _LetterApi(this._read);

  final Reader _read;

  Future<List<Letter>> findAll() async {
    final String json = await _read(rsServiceProvider).readLettersJson();
    return LetterJson.parse(json);
  }

  Future<String> findImageUrl(String fileName) async {
    return await _read(rsServiceProvider).getLetterImageUrl(fileName);
  }
}
