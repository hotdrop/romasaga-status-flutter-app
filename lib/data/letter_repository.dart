import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/remote/response/letter_response.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/data/local/dao/letter_dao.dart';
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
    final response = await _read(letterApiProvider).findAll();
    final localLetters = await _read(letterDaoProvider).findAll();
    RSLogger.d('お便り情報を取得しました。 リモートのデータ件数=${response.letters.length} 端末に登録されているデータ件数=${localLetters.length}');

    final mergeLetters = await _merge(response.letters, localLetters);
    await _read(letterDaoProvider).saveAll(mergeLetters);
  }

  Future<List<Letter>> _merge(List<LetterResponse> responses, List<Letter> localLetters) async {
    final results = <Letter>[];
    for (var response in responses) {
      final current = localLetters.firstWhereOrNull((l) => l.year == response.year && l.month == response.month);
      if (current != null) {
        results.add(current);
      } else {
        final newLetter = await _toLetter(response);
        results.add(newLetter);
      }
    }
    return results;
  }

  Future<void> refresh() async {
    final response = await _read(letterApiProvider).findAll();
    RSLogger.d('リモートからデータ取得 件数=${response.letters.length}');

    final letters = await Future.wait(
      response.letters.map((r) async => await _toLetter(r)).toList(),
    );
    await _read(letterDaoProvider).saveAll(letters);
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

  Future<Letter> _toLetter(LetterResponse response) async {
    final gifPath = await _read(letterApiProvider).findImageUrl('${response.imageName}.gif');
    final imagePath = await _read(letterApiProvider).findImageUrl('${response.imageName}_static.jpg');
    RSLogger.d('お便り letters/${response.imageName} のフルパスを取得しました。\n gifPath=$gifPath staticPath=$imagePath');

    return Letter(
      year: response.year,
      month: response.month,
      title: response.title,
      shortTitle: response.shortTitle,
      gifFilePath: gifPath,
      staticImagePath: imagePath,
    );
  }
}
