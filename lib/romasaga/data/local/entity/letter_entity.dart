class LetterEntity {
  LetterEntity(this.year, this.month, this.title, this.shortTitle, this.gifFilePath, this.staticImagePath);

  LetterEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId] as int,
        year = map[columnYear] as int,
        month = map[columnMonth] as int,
        title = map[columnTitle] as String,
        shortTitle = map[columnShortTitle] as String,
        gifFilePath = map[columnGifFilePath] as String,
        staticImagePath = map[columnStaticImagePath] as String;

  static const String tableName = 'Letter';
  static const String createTableSql = '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY autoincrement,
        $columnYear INTEGER,
        $columnMonth INTEGER,
        $columnTitle TEXT,
        $columnShortTitle TEXT,
        $columnGifFilePath TEXT,
        $columnStaticImagePath TEXT
      )
      ''';

  static const String columnId = 'id';
  int id;

  static const String columnYear = 'year';
  final int year;

  static const String columnMonth = 'month';
  final int month;

  static const String columnTitle = 'title';
  final String title;

  static const String columnShortTitle = 'shortTitle';
  final String shortTitle;

  static const String columnGifFilePath = 'gifFilePath';
  final String gifFilePath;

  static const String columnStaticImagePath = 'staticImagePath';
  final String staticImagePath;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      columnYear: year,
      columnMonth: month,
      columnTitle: title,
      columnShortTitle: shortTitle,
      columnGifFilePath: gifFilePath,
      columnStaticImagePath: staticImagePath,
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }
}
