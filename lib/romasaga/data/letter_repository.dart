import 'local/letter_dao.dart';
import 'remote/letter_api.dart';

import '../model/letter.dart';

import '../common/rs_logger.dart';

class LetterRepository {
  const LetterRepository._(this._dao, this._api);

  factory LetterRepository.create() {
    final api = LetterApi.create();
    final dao = LetterDao.create();
    return LetterRepository._(dao, api);
  }

  final LetterDao _dao;
  final LetterApi _api;

  ///
  /// お便りデータを取得
  ///
  Future<List<Letter>> findAll() async {
    var letters = await _dao.findAll();

    if (letters.isEmpty) {
      RSLogger.d('保持しているデータが0件のためリモートから取得します。');
      letters = await _api.findAll();
      await _dao.refresh(letters);
    }

    return letters;
  }

  Future<void> update() async {
    final localLetters = await _dao.findAll();
    RSLogger.d('ローカルからデータ取得 件数=${localLetters.length}');

    final newLetters = await _api.findNew(localLetters);

    await _dao.refresh(newLetters);
  }
}
