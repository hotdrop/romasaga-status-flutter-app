import 'local_data_source.dart';
import '../model/character.dart';

class RomasagaRepository {
  Future<List<Character>> findAll() async {
    final localDataSource = LocalDataSource();
    return await localDataSource.findAll();
  }
}
