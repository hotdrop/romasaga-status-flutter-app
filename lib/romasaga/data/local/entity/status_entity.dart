class StatusEntity {
  StatusEntity(this.charName, this.hp, this.str, this.vit, this.dex, this.agi, this.intelligence, this.spirit, this.love, this.attr);

  StatusEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        charName = map[columnCharName],
        hp = map[columnHp],
        str = map[columnStr],
        vit = map[columnVit],
        dex = map[columnDex],
        agi = map[columnAgi],
        intelligence = map[columnInt],
        spirit = map[columnSpirit],
        love = map[columnLove],
        attr = map[columnAttr];

  static const String tableName = "Status";
  static const String createTableSql = """
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY autoincrement,
        $columnCharName TEXT,
        $columnHp INTEGER,
        $columnStr INTEGER,
        $columnVit INTEGER,
        $columnDex INTEGER,
        $columnAgi INTEGER,
        $columnInt INTEGER,
        $columnSpirit INTEGER,
        $columnLove INTEGER,
        $columnAttr INTEGER
      )
      """;

  static const String columnId = "id";
  int id;

  static const String columnCharName = "char_name";
  final String charName;

  static const String columnHp = "hp";
  final int hp;

  static const String columnStr = "str";
  final int str;

  static const String columnVit = "vit";
  final int vit;

  static const String columnDex = "dex";
  final int dex;

  static const String columnAgi = "agi";
  final int agi;

  static const String columnInt = "intelligence";
  final int intelligence;

  static const String columnSpirit = "spirit";
  final int spirit;

  static const String columnLove = "love";
  final int love;

  static const String columnAttr = "attr";
  final int attr;

  Map<String, dynamic> toMap() {
    var map;
    map = <String, dynamic>{
      columnCharName: charName,
      columnHp: hp,
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
