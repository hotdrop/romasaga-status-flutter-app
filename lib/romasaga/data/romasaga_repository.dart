import 'romasaga_file.dart';
import '../model/character.dart';

class RomasagaRepository {
  Future<List<Character>> findAll() async {
    // これstreamにすべき
    print('repository start');
    final file = RomasagaFile();
    print('repository complete read file');
    return file.read();
  }
}
