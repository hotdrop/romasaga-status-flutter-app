import '../common/strings.dart';

class Style {
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

  const Style(
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

  static int rankSort(String first, String second) {
    final firstPriority = (first == Strings.RankA) ? 1 : (first == Strings.RankS) ? 2 : 3;
    final secondPriority = (second == Strings.RankA) ? 1 : (second == Strings.RankS) ? 2 : 3;
    if (firstPriority < secondPriority) {
      return -1;
    } else if (firstPriority == secondPriority) {
      return 0;
    } else {
      return 1;
    }
  }
}
