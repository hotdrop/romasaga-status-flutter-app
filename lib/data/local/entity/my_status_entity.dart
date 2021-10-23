class MyStatusEntity {
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
      : id = map[columnId] as int,
        hp = map[columnHp] as int,
        str = map[columnStr] as int,
        vit = map[columnVit] as int,
        dex = map[columnDex] as int,
        agi = map[columnAgi] as int,
        intelligence = map[columnInt] as int,
        spirit = map[columnSpirit] as int,
        love = map[columnLove] as int,
        attr = map[columnAttr] as int,
        charHave = map[columnHaveChar] as int,
        favorite = map[columnFavorite] as int;

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
