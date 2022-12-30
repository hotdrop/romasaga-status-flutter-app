import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/remote/response/letter_response.dart';
import 'package:rsapp/service/rs_service.dart';

final letterApiProvider = Provider((ref) => _LetterApi(ref));

class _LetterApi {
  const _LetterApi(this._ref);

  final Ref _ref;

  Future<LettersResponse> findAll() async {
    final responseRow = await _ref.read(rsServiceProvider).getLetters() as Map<String, dynamic>;
    return LettersResponse.fromJson(responseRow);
  }

  Future<String> findImageUrl(String fileName) async {
    return await _ref.read(rsServiceProvider).getLetterImageUrl(fileName);
  }
}
