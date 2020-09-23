import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/json/letter_json.dart';
import 'package:rsapp/romasaga/model/letter.dart';
import 'package:rsapp/romasaga/service/rs_service.dart';

class LetterApi {
  const LetterApi._(this._rsService);

  factory LetterApi.create() {
    return LetterApi._(RSService.getInstance());
  }

  final RSService _rsService;

  ///
  /// ネットワーク経由で「お便りモデル」クラスのリストを取得する。
  /// gifと画像名からStorageのフルパスを取得する処理がかなり重いので毎回更新のたびにやるとうざい。
  /// そのため、新たに追加されたデータのみ差分取得する。
  ///
  Future<List<Letter>> findNew(List<Letter> currentLetters) async {
    final json = await _rsService.readLettersJson();
    final letterObjects = LetterJson.parse(json);

    List<Letter> newLetters = [];

    for (var obj in letterObjects) {
      var current = currentLetters.firstWhere((letter) => letter.year == obj.year && letter.month == obj.month, orElse: () => null);

      Letter newLetter;
      if (current != null) {
        newLetter = LetterJson.toModel(obj, gifFilePath: current.gifFilePath, staticImagePath: current.staticImagePath);
      } else {
        String gifPath = await _rsService.getLetterImageUrl(obj.gifFileName);
        RSLogger.d('お便り letters/${obj.gifFileName} のフルパスを取得しました。\n path=$gifPath');

        String imagePath = await _rsService.getLetterImageUrl(obj.staticImageFileName);
        RSLogger.d('お便り letters/${obj.staticImageFileName} のフルパスを取得します。\n path=$imagePath');

        newLetter = LetterJson.toModel(obj, gifFilePath: gifPath, staticImagePath: imagePath);
      }
      newLetters.add(newLetter);
    }

    return newLetters;
  }
}
