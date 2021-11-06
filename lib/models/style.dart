import 'package:rsapp/res/rs_strings.dart';

class Style {
  Style(
    this.id,
    this.characterId,
    this.rank,
    this.title,
    this.iconFileName,
    this.iconFilePath,
    this.str,
    this.vit,
    this.dex,
    this.agi,
    this.intelligence,
    this.spirit,
    this.love,
    this.attr,
  );

  final int id;
  final int characterId;
  final String rank;
  final String title;
  final String iconFileName;
  final String iconFilePath;
  final int str;
  final int vit;
  final int dex;
  final int agi;
  final int intelligence;
  final int spirit;
  final int love;
  final int attr;

  static int rankSort(String first, String second) {
    final firstPriority = (first == RSStrings.rankA)
        ? 1
        : (first == RSStrings.rankS)
            ? 2
            : 3;
    final secondPriority = (second == RSStrings.rankA)
        ? 1
        : (second == RSStrings.rankS)
            ? 2
            : 3;
    if (firstPriority < secondPriority) {
      return -1;
    } else if (firstPriority == secondPriority) {
      return 0;
    } else {
      return 1;
    }
  }

  int sum() => str + vit + dex + agi + intelligence + spirit + love + attr;

  static int makeId(int charId, int index) {
    final idStr = '$charId${index.toString().padLeft(3, '0')}';
    return int.parse(idStr);
  }
}
