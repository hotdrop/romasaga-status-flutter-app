class CharacterEntity {
  static const String tableName = 'Character';
  static const String createTableSql = '''
      CREATE TABLE $tableName (
        $columnId INTEGER,
        $columnName TEXT,
        $columnProduction TEXT,
        $columnWeaponType TEXT,
        $columnSelectedStyleRank TEXT,
        $columnSelectedIconFileName TEXT
      )
      ''';

  static const String columnId = 'id';
  final int id;

  static const String columnName = 'name';
  final String name;

  static const String columnProduction = 'production';
  final String production;

  static const String columnWeaponType = 'weapon_type';
  final String weaponType;

  static const String columnSelectedStyleRank = 'selected_style_rank';
  final String selectedStyleRank;

  static const String columnSelectedIconFileName = 'selected_icon_file_name';
  final String selectedIconFileName;

  const CharacterEntity(
    this.id,
    this.name,
    this.production,
    this.weaponType,
    this.selectedStyleRank,
    this.selectedIconFileName,
  );

  CharacterEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName],
        production = map[columnProduction],
        weaponType = map[columnWeaponType],
        selectedStyleRank = map[columnSelectedStyleRank],
        selectedIconFileName = map[columnSelectedIconFileName];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnId: id,
      columnName: name,
      columnProduction: production,
      columnWeaponType: weaponType,
      columnSelectedStyleRank: selectedStyleRank,
      columnSelectedIconFileName: selectedIconFileName,
    };
  }
}
