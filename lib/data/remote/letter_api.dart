import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/remote/response/letter_response.dart';
import 'package:rsapp/service/rs_service.dart';

final letterApiProvider = Provider((ref) => _LetterApi(ref.read));

class _LetterApi {
  const _LetterApi(this._read);

  final Reader _read;

  Future<List<LetterResponse>> findAll() async {
    final responseRow = await _read(rsServiceProvider).getLetters() as List<dynamic>;
    return responseRow //
        .map((dynamic d) => d as Map<String, Object?>)
        .map((dmap) => LetterResponse.fromJson(dmap))
        .toList();
  }

  Future<String> findImageUrl(String fileName) async {
    return await _read(rsServiceProvider).getLetterImageUrl(fileName);
  }
}
