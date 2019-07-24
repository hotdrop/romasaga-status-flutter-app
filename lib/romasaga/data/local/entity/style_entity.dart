class StyleEntity {
  static const String tableName = 'Style';
  static const String createTableSql = '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY autoincrement,
        $columnCharacterId INTEGER,
        $columnRank TEXT,
        $columnTitle TEXT,
        $columnIconFileName TEXT,
        $columnStr INTEGER,
        $columnVit INTEGER,
        $columnDex INTEGER,
        $columnAgi INTEGER,
        $columnInt INTEGER,
        $columnSpirit INTEGER,
        $columnLove INTEGER,
        $columnAttr INTEGER
      )
      ''';

  static const String columnId = 'id';
  int id;

  static const String columnCharacterId = 'character_id';
  final int characterId;

  static const String columnRank = 'rank';
  final String rank;

  static const String columnTitle = 'title';
  final String title;

  static const String columnIconFileName = 'icon_file_name';
  final String iconFileName;

  static const String columnStr = 'str';
  final int str;

  static const String columnVit = 'vit';
  final int vit;

  static const String columnDex = 'dex';
  final int dex;

  static const String columnAgi = 'agi';
  final int agi;

  static const String columnInt = 'intelligence';
  final int intelligence;

  static const String columnSpirit = 'spirit';
  final int spirit;

  static const String columnLove = 'love';
  final int love;

  static const String columnAttr = 'attr';
  final int attr;

  StyleEntity(
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

  StyleEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        characterId = map[columnCharacterId],
        rank = map[columnRank],
        title = map[columnTitle],
        iconFileName = map[columnIconFileName],
        str = map[columnStr],
        vit = map[columnVit],
        dex = map[columnDex],
        agi = map[columnAgi],
        intelligence = map[columnInt],
        spirit = map[columnSpirit],
        love = map[columnLove],
        attr = map[columnAttr];

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      columnCharacterId: characterId,
      columnRank: rank,
      columnTitle: title,
      columnIconFileName: iconFileName,
      columnStr: str,
      columnVit: vit,
      columnDex: dex,
      columnAgi: agi,
      columnInt: intelligence,
      columnSpirit: spirit,
      columnLove: love,
      columnAttr: attr,
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }
}
