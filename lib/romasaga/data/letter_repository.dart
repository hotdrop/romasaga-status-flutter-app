import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/romasaga/data/local/letter_dao.dart';
import 'package:rsapp/romasaga/data/remote/letter_api.dart';
import 'package:rsapp/romasaga/model/letter.dart';

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
    List<Letter> letters = await _dao.findAll();

    if (letters.isEmpty) {
      RSLogger.d('保持しているお便りデータはありません。');
    }

    return letters;
  }

  Future<void> update() async {
    final remoteLetters = await _api.findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteLetters.length}');

    final localLetters = await _dao.findAll();
    RSLogger.d('ローカルからデータ取得 件数=${localLetters.length}');

    final mergeLetters = await _merge(remoteLetters, localLetters);

    await _dao.refresh(mergeLetters);
  }

  Future<List<Letter>> _merge(List<Letter> remoteLetters, List<Letter> localLetters) async {
    final List<Letter> results = [];

    for (var remote in remoteLetters) {
      Letter current = localLetters.firstWhere((l) => l.year == remote.year && l.month == remote.month, orElse: () => null);

      if (current != null) {
        results.add(current);
      } else {
        final String gifPath = await _api.findImageUrl('${remote.fileName}.gif');
        RSLogger.d('お便り letters/${remote.fileName} のフルパスを取得しました。\n path=$gifPath');

        String imagePath = await _api.findImageUrl('${remote.fileName}_static.jpg');
        RSLogger.d('お便り letters/${remote.fileName}_static.jpg のフルパスを取得します。\n path=$imagePath');

        final newLetter = remote.copyWith(gifFilePath: gifPath, staticImagePath: imagePath);
        results.add(newLetter);
      }
    }

    return results;
  }

  Future<void> refresh() async {
    final remoteLetters = await _api.findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteLetters.length}');

    final lettersWithFilePath = await _attachFilePath(remoteLetters);
    await _dao.refresh(lettersWithFilePath);
  }

  Future<List<Letter>> _attachFilePath(List<Letter> letters) async {
    final List<Letter> results = [];

    for (var remote in letters) {
      final String gifPath = await _api.findImageUrl('${remote.fileName}.gif');
      RSLogger.d('お便り letters/${remote.fileName} のフルパスを取得しました。\n path=$gifPath');

      final String imagePath = await _api.findImageUrl('${remote.fileName}_static.jpg');
      RSLogger.d('お便り letters/${remote.fileName}_static.jpg のフルパスを取得します。\n path=$imagePath');

      final Letter l = remote.copyWith(gifFilePath: gifPath, staticImagePath: imagePath);
      results.add(l);
    }

    return results;
  }

  Future<String> getLatestLetterName() async {
    final letters = await _dao.findAll();
    if (letters.isEmpty) {
      return RSStrings.accountLetterEmptyLabel;
    } else {
      final latestLetter = letters.last;
      return '${latestLetter.year}${RSStrings.letterYearLabel}${latestLetter.month}${RSStrings.letterMonthLabel} ${latestLetter.shortTitle}';
    }
  }
}
