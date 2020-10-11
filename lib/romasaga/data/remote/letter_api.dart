import 'package:rsapp/romasaga/data/json/letter_json.dart';
import 'package:rsapp/romasaga/model/letter.dart';
import 'package:rsapp/romasaga/service/rs_service.dart';

class LetterApi {
  const LetterApi._(this._rsService);

  factory LetterApi.create() {
    return LetterApi._(RSService.getInstance());
  }

  final RSService _rsService;

  Future<List<Letter>> findAll() async {
    final String json = await _rsService.readLettersJson();
    return LetterJson.parse(json);
  }

  Future<String> findImageUrl(String fileName) async => await _rsService.getLetterImageUrl(fileName);
}
