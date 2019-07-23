class StageEntity {
  StageEntity(this.name, this.statusUpperLimit, this.itemOrder);

  StageEntity.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName],
        statusUpperLimit = map[columnAddLimit],
        itemOrder = map[columnOrder];

  static const String tableName = 'Stage';
  static const String createTableSql = '''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY autoincrement,
        $columnName TEXT,
        $columnAddLimit INTEGER,
        $columnOrder INTEGER
      )
      ''';

  static const String columnId = 'id';
  int id;

  static const String columnName = 'name';
  final String name;

  static const String columnAddLimit = 'status_upper_limit';
  final int statusUpperLimit;

  static const String columnOrder = 'item_order';
  final int itemOrder;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{columnName: name, columnAddLimit: statusUpperLimit, columnOrder: itemOrder};

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }
}
