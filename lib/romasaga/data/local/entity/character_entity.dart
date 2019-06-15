class CharacterEntity {
  static const String tableName = "Character";

  static const String columnId = "id";
  int id;

  static const String columnName = "name";
  String name;

  static const String columnWeaponType = "weapon_type";
  String weaponType;

  static const String columnRank = "rank";
  String rank;

  static const String columnStr = "str";
  int str;

  static const String columnVit = "vit";
  int vit;

  static const String columnDex = "dex";
  int dex;

  static const String columnAgi = "agi";
  int agi;

  static const String columnInt = "intelligence";
  int intelligence;

  static const String columnSpirit = "spirit";
  int spirit;

  static const String columnLove = "love";
  int love;

  static const String columnAttr = "attr";
  int attr;

  CharacterEntity();

  Map<String, dynamic> toMap() {
    var map;
    map = <String, dynamic>{
      columnName: name,
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

  CharacterEntity.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    weaponType = map[columnWeaponType];

    rank = map[columnRank];
    str = map[columnStr];
    vit = map[columnVit];
    dex = map[columnDex];
    agi = map[columnAgi];
    intelligence = map[columnInt];
    spirit = map[columnSpirit];
    love = map[columnLove];
    attr = map[columnAttr];
  }
}
