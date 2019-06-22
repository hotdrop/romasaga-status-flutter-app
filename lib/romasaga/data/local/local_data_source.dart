import 'database.dart';
import '../../model/character.dart';
import 'mapper.dart';

class LocalDataSource {
  LocalDataSource._();
  static final LocalDataSource _instance = LocalDataSource._();

  factory LocalDataSource() {
    return _instance;
  }

  void save(List<Character> characters) {
    characters.forEach((character) {
      final entities = Mapper.toEntities(character);
      entities.forEach((entity) async {
        await DBProvider.db.insert(entity);
      });
    });
  }

  Future<List<Character>> findAll() async {
    return await DBProvider.db.selectAll().then((entities) {
      return Mapper.toCharacters(entities);
    }, onError: (e) {
      throw e;
    });
  }
}
