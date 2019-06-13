import 'package:flutter/foundation.dart' as foundation;

import '../data/romasaga_repository.dart';
import '../model/character.dart';

class CharListViewModel extends foundation.ChangeNotifier {
  List<Character> _characters;

  List<Character> findAll() {
    if (_characters == null) {
      print('ViewModel return empty');
      return [];
    }

    print('ViewModel return char. size=${_characters.length}');
    return _characters;
  }

  void load() async {
    // TODO これProviderでなんとかならんか
    final repository = RomasagaRepository();
    print('ViewModel load Start!');
    _characters = await repository.findAll();
    print('ViewModel load End! size=${_characters.length}');
    notifyListeners();
  }
}
