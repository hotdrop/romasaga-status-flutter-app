class CharacterEntity {
  const CharacterEntity(
    this.id,
    this.name,
    this.production,
    this.weaponType,
    this.attributeTypes,
    this.selectedStyleRank,
    this.selectedIconFilePath,
  );

  CharacterEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId] as int,
        name = map[columnName] as String,
        production = map[columnProduction] as String,
        weaponType = map[columnWeaponType] as int,
        attributeTypes = map[columnAttributeTypes] as String,
        selectedStyleRank = map[columnSelectedStyleRank] as String,
        selectedIconFilePath = map[columnSelectedIconFilePath] as String;

  static const String tableName = 'Character';
  static const String createTableSql = '''
      CREATE TABLE $tableName (
        $columnId INTEGER,
        $columnName TEXT,
        $columnProduction TEXT,
        $columnWeaponType INTEGER,
        $columnAttributeTypes TEXT,
        $columnSelectedStyleRank TEXT,
        $columnSelectedIconFilePath TEXT
      )
      ''';

  static const String columnId = 'id';
  final int id;

  static const String columnName = 'name';
  final String name;

  static const String columnProduction = 'production';
  final String production;

  static const String columnWeaponType = 'weapon_type';
  final int weaponType;

  static const String columnAttributeTypes = 'attributes';
  final String attributeTypes;

  static const String columnSelectedStyleRank = 'selected_style_rank';
  final String selectedStyleRank;

  static const String columnSelectedIconFilePath = 'selected_icon_file_path';
  final String selectedIconFilePath;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnId: id,
      columnName: name,
      columnProduction: production,
      columnWeaponType: weaponType,
      columnAttributeTypes: attributeTypes,
      columnSelectedStyleRank: selectedStyleRank,
      columnSelectedIconFilePath: selectedIconFilePath,
    };
  }
}
