import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/data/local/letter_dao.dart';
import 'package:rsapp/data/remote/letter_api.dart';
import 'package:rsapp/models/letter.dart';

final letterRepositoryProvider = Provider((ref) => _LetterRepository(ref.read));

class _LetterRepository {
  const _LetterRepository(this._read);

  final Reader _read;

  ///
  /// お便りデータを取得
  ///
  Future<List<Letter>> findAll() async {
    List<Letter> letters = await _read(letterDaoProvider).findAll();

    if (letters.isEmpty) {
      RSLogger.d('保持しているお便りデータはありません。');
    }

    return letters;
  }

  Future<void> update() async {
    final remoteLetters = await _read(letterApiProvider).findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteLetters.length}');

    final localLetters = await _read(letterDaoProvider).findAll();
    RSLogger.d('ローカルからデータ取得 件数=${localLetters.length}');

    final mergeLetters = await _merge(remoteLetters, localLetters);

    await _read(letterDaoProvider).refresh(mergeLetters);
  }

  Future<List<Letter>> _merge(List<Letter> remoteLetters, List<Letter> localLetters) async {
    final List<Letter> results = [];

    for (var remote in remoteLetters) {
      final current = localLetters.firstWhereOrNull((l) => l.year == remote.year && l.month == remote.month);

      if (current != null) {
        results.add(current);
      } else {
        final String gifPath = await _read(letterApiProvider).findImageUrl('${remote.fileName}.gif');
        RSLogger.d('お便り letters/${remote.fileName} のフルパスを取得しました。\n path=$gifPath');

        String imagePath = await _read(letterApiProvider).findImageUrl('${remote.fileName}_static.jpg');
        RSLogger.d('お便り letters/${remote.fileName}_static.jpg のフルパスを取得します。\n path=$imagePath');

        final newLetter = remote.copyWith(gifFilePath: gifPath, staticImagePath: imagePath);
        results.add(newLetter);
      }
    }

    return results;
  }

  Future<void> refresh() async {
    final remoteLetters = await _read(letterApiProvider).findAll();
    RSLogger.d('リモートからデータ取得 件数=${remoteLetters.length}');

    final lettersWithFilePath = await _attachFilePath(remoteLetters);
    await _read(letterDaoProvider).refresh(lettersWithFilePath);
  }

  Future<List<Letter>> _attachFilePath(List<Letter> letters) async {
    final List<Letter> results = [];

    for (var remote in letters) {
      final String gifPath = await _read(letterApiProvider).findImageUrl('${remote.fileName}.gif');
      RSLogger.d('お便り letters/${remote.fileName} のフルパスを取得しました。\n path=$gifPath');

      final String imagePath = await _read(letterApiProvider).findImageUrl('${remote.fileName}_static.jpg');
      RSLogger.d('お便り letters/${remote.fileName}_static.jpg のフルパスを取得します。\n path=$imagePath');

      final Letter l = remote.copyWith(gifFilePath: gifPath, staticImagePath: imagePath);
      results.add(l);
    }

    return results;
  }

  Future<String> getLatestLetterName() async {
    final letters = await _read(letterDaoProvider).findAll();
    if (letters.isEmpty) {
      return RSStrings.accountLetterEmptyLabel;
    } else {
      final latestLetter = letters.last;
      return '${latestLetter.year}${RSStrings.letterYearLabel}${latestLetter.month}${RSStrings.letterMonthLabel} ${latestLetter.shortTitle}';
    }
  }
}
