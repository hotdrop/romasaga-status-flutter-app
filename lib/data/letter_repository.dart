import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/remote/response/letter_response.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/data/local/dao/letter_dao.dart';
import 'package:rsapp/data/remote/letter_api.dart';
import 'package:rsapp/models/letter.dart';

final letterRepositoryProvider = Provider((ref) => _LetterRepository(ref));

class _LetterRepository {
  const _LetterRepository(this._ref);

  final Ref _ref;

  ///
  /// お便りデータを取得
  ///
  Future<List<Letter>> findAll() async {
    List<Letter> letters = await _ref.read(letterDaoProvider).findAll();

    if (letters.isEmpty) {
      RSLogger.d('保持しているお便りデータはありません。');
    }

    return letters;
  }

  Future<void> update() async {
    final response = await _ref.read(letterApiProvider).findAll();
    final localLetters = await _ref.read(letterDaoProvider).findAll();
    RSLogger.d('お便り情報を取得しました。 リモートのデータ件数=${response.letters.length} 端末に登録されているデータ件数=${localLetters.length}');

    final mergeLetters = await _merge(response.letters, localLetters);
    await _ref.read(letterDaoProvider).saveAll(mergeLetters);
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

  Future<Letter> _toLetter(LetterResponse response) async {
    final videoPath = await _ref.read(letterApiProvider).findImageUrl('${response.imageName}.mp4');
    final imagePath = await _ref.read(letterApiProvider).findImageUrl('${response.imageName}_static.jpg');
    RSLogger.d('お便り letters/${response.imageName} のフルパスを取得しました。\n videoPath=$videoPath staticPath=$imagePath');

    return Letter(
      year: response.year,
      month: response.month,
      title: response.title,
      shortTitle: response.shortTitle,
      videoFilePath: videoPath,
      staticImagePath: imagePath,
    );
  }

  Future<String?> getLatestLetterName() async {
    final letters = await _ref.read(letterDaoProvider).findAll();
    if (letters.isEmpty) {
      return null;
    } else {
      final latestLetter = letters.last;
      return '${latestLetter.year}${RSStrings.letterYearLabel}${latestLetter.month}${RSStrings.letterMonthLabel} ${latestLetter.shortTitle}';
    }
  }
}
