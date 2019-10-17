import '../common/rs_strings.dart';

class Style {
  Style(
    this.characterId,
    this.rank,
    this.title,
    this.iconFileName,
    this.str,
    this.vit,
    this.dex,
    this.agi,
    this.intelligence,
    this.spirit,
    this.love,
    this.attr,
  );

  final int characterId;
  final String rank;
  final String title;
  final String iconFileName;

  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int intelligence;
  final int spirit;
  final int love;
  final int attr;

  // アイコンはネットワーク経由で取得するためパスを別に取得する必要がありfinalをつけていない
  String iconFilePath;

  static int rankSort(String first, String second) {
    final firstPriority = (first == RSStrings.rankA) ? 1 : (first == RSStrings.rankS) ? 2 : 3;
    final secondPriority = (second == RSStrings.rankA) ? 1 : (second == RSStrings.rankS) ? 2 : 3;
    if (firstPriority < secondPriority) {
      return -1;
    } else if (firstPriority == secondPriority) {
      return 0;
    } else {
      return 1;
    }
  }
}
