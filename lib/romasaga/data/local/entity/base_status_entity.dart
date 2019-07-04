class BaseStatusEntity {
  static const String tableName = "BaseStatus";
  static const String createTableSql = """
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY autoincrement,
        $columnName TEXT,
        $columnAddLimit INTEGER,
        $columnOrder INTEGER
      )
      """;

  static const String columnId = "id";
  int id;

  static const String columnName = "stage_name";
  final String stageName;

  static const String columnAddLimit = "add_limit";
  final int addLimit;

  static const String columnOrder = "item_order";
  final int itemOrder;

  BaseStatusEntity(this.stageName, this.addLimit, this.itemOrder);

  Map<String, dynamic> toMap() {
    var map;
    map = <String, dynamic>{columnName: stageName, columnAddLimit: addLimit, columnOrder: itemOrder};

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

  static BaseStatusEntity fromMap(Map<String, dynamic> map) =>
      BaseStatusEntity(map[columnName], map[columnAddLimit], map[columnOrder])..id = map[columnId];
}
