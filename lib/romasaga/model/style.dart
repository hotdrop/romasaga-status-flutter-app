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

  static const String rankSS = 'SS';
  static const String rankS = 'S';
  static const String rankA = 'A';

  static int rankSort(String first, String second) {
    final firstPriority = (first == rankA) ? 1 : (first == rankS) ? 2 : 3;
    final secondPriority = (second == rankA) ? 1 : (second == rankS) ? 2 : 3;
    if (firstPriority < secondPriority) {
      return -1;
    } else if (firstPriority == secondPriority) {
      return 0;
    } else {
      return 1;
    }
  }
}
