import 'package:rsapp/romasaga/data/local/letter_dao.dart';
import 'package:rsapp/romasaga/model/letter.dart';

class LetterRepository {
  const LetterRepository._(this._dao);

  factory LetterRepository.create() {
    final api = LetterDao.create();
    return LetterRepository._(api);
  }

  final LetterDao _dao;

  ///
  /// お便りデータを取得
  ///
  Future<List<Letter>> findAll() async {
    return await _dao.findAll();
  }
}
