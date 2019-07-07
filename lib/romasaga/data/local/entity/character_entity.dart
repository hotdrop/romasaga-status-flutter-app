class CharacterEntity {
  static const String tableName = "Character";
  static const String createTableSql = """
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY autoincrement,
        $columnName TEXT,
        $columnTitle TEXT,
        $columnProduction TEXT,
        $columnWeaponType TEXT,
        $columnRank TEXT,
        $columnStr INTEGER,
        $columnVit INTEGER,
        $columnDex INTEGER,
        $columnAgi INTEGER,
        $columnInt INTEGER,
        $columnSpirit INTEGER,
        $columnLove INTEGER,
        $columnAttr INTEGER,
        $columnIconFileName TEXT
      )
      """;

  static const String columnId = "id";
  int id;

  static const String columnName = "name";
  final String name;

  static const String columnTitle = "title";
  final String title;

  static const String columnProduction = "production";
  final String production;

  static const String columnWeaponType = "weapon_type";
  final String weaponType;

  static const String columnRank = "rank";
  final String rank;

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

  static const String columnIconFileName = "file_name";
  final String iconFileName;

  CharacterEntity(this.name, this.title, this.production, this.weaponType, this.rank, this.str, this.vit, this.dex, this.agi, this.intelligence,
      this.spirit, this.love, this.attr, this.iconFileName);

  Map<String, dynamic> toMap() {
    var map;
    map = <String, dynamic>{
      columnName: name,
      columnTitle: title,
      columnProduction: production,
      columnWeaponType: weaponType,
      columnRank: rank,
      columnStr: str,
      columnVit: vit,
      columnDex: dex,
      columnAgi: agi,
      columnInt: intelligence,
      columnSpirit: spirit,
      columnLove: love,
      columnAttr: attr
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

  static CharacterEntity fromMap(Map<String, dynamic> map) => CharacterEntity(
        map[columnName],
        map[columnTitle],
        map[columnProduction],
        map[columnWeaponType],
        map[columnRank],
        map[columnStr],
        map[columnVit],
        map[columnDex],
        map[columnAgi],
        map[columnInt],
        map[columnSpirit],
        map[columnLove],
        map[columnAttr],
        map[columnIconFileName],
      )..id = map[columnId];
}
