class MyStatusEntity {
  static const String tableName = 'MyStatus';
  static const String createTableSql = '''
      CREATE TABLE $tableName (
        $columnId INTEGER,
        $columnHp INTEGER,
        $columnStr INTEGER,
        $columnVit INTEGER,
        $columnDex INTEGER,
        $columnAgi INTEGER,
        $columnInt INTEGER,
        $columnSpirit INTEGER,
        $columnLove INTEGER,
        $columnAttr INTEGER,
        $columnHaveChar INTEGER,
        $columnFavorite INTEGER
      )
      ''';

  static const String columnId = 'id';
  final int id;

  static const String columnHp = 'hp';
  final int hp;

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

  static const String columnHaveChar = 'have_char';
  static const int haveChar = 1;
  static const int notHaveChar = 0;
  final int charHave;

  static const String columnFavorite = 'favorite';
  static const int isFavorite = 1;
  static const int notFavorite = 0;
  final int favorite;

  const MyStatusEntity(
    this.id,
    this.hp,
    this.str,
    this.vit,
    this.dex,
    this.agi,
    this.intelligence,
    this.spirit,
    this.love,
    this.attr,
    this.charHave,
    this.favorite,
  );

  MyStatusEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        hp = map[columnHp],
        str = map[columnStr],
        vit = map[columnVit],
        dex = map[columnDex],
        agi = map[columnAgi],
        intelligence = map[columnInt],
        spirit = map[columnSpirit],
        love = map[columnLove],
        attr = map[columnAttr],
        charHave = map[columnHaveChar],
        favorite = map[columnFavorite];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnId: id,
      columnHp: hp,
      columnStr: str,
      columnVit: vit,
      columnDex: dex,
      columnAgi: agi,
      columnInt: intelligence,
      columnSpirit: spirit,
      columnLove: love,
      columnAttr: attr,
      columnHaveChar: charHave,
      columnFavorite: favorite,
    };
  }
}
