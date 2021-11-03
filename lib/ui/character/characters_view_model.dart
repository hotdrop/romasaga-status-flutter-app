import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/data/character_repository.dart';
import 'package:rsapp/data/my_status_repository.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/status.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:collection/collection.dart';

final charactersViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  return _CharactersViewModel(ref.read);
});

class _CharactersViewModel extends BaseViewModel {
  _CharactersViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late List<Character> _characters;
  List<Character> get statusUpCharacters => _characters.where((c) => c.statusUpEvent).toList();
  int get countStatusUpCharacters => statusUpCharacters.length;

  List<Character> get favoriteCharacters => _characters.where((c) => c.myStatus?.favorite ?? false).toList();
  int get countFavoriteCharacters => favoriteCharacters.length;

  List<Character> get notFavoriteCharacters => _characters.where((c) => !(c.myStatus?.favorite ?? false)).toList();
  int get countNotFavoriteCharacters => notFavoriteCharacters.length;

  late CharacterListOrderType _selectedOrderType;
  CharacterListOrderType get selectedOrderType => _selectedOrderType;

  Future<void> _init() async {
    try {
      await _refreshAllData();
      onSuccess();
    } catch (e, s) {
      RSLogger.e('キャラ一覧取得でエラー', e, s);
      onError('$e');
    }
  }

  Future<void> refresh() async {
    try {
      await _refreshAllData();
      notifyListeners();
    } catch (e) {
      onError('$e');
    }
  }

  Future<void> _refreshAllData() async {
    final characters = await _read(characterRepositoryProvider).findAll();
    final myStatuses = await _read(myStatusRepositoryProvider).findAll();
    _characters = await _merge(characters, myStatuses);

    _selectedOrderType = _read(appSettingsProvider).characterListOrderType;
    _charactersOrderBy(_selectedOrderType);
  }

  Future<List<Character>> _merge(List<Character> characters, List<MyStatus> statues) async {
    if (statues.isNotEmpty) {
      RSLogger.d('登録ステータス${statues.length}件をキャラ情報にマージします。');
      List<Character> newCharacters = [];
      for (var c in characters) {
        final status = statues.firstWhereOrNull((s) => s.id == c.id);
        if (status != null) {
          newCharacters.add(c.withStatus(status));
        } else {
          newCharacters.add(c);
        }
      }
      return newCharacters;
    } else {
      RSLogger.d('登録ステータスは0件です。');
      return characters;
    }
  }

  void selectOrder(CharacterListOrderType type) {
    _selectedOrderType = type;
    _charactersOrderBy(type);
    notifyListeners();
  }

  void _charactersOrderBy(CharacterListOrderType orderType) {
    switch (orderType) {
      case CharacterListOrderType.hp:
        _characters.sort((c1, c2) {
          final t = c2.myStatus?.hp ?? 0;
          final v = c1.myStatus?.hp ?? 0;
          return t.compareTo(v);
        });
        break;
      case CharacterListOrderType.production:
        _characters.sort((c1, c2) => c1.id.compareTo(c2.id));
        break;
      case CharacterListOrderType.status:
        _characters.sort((c1, c2) {
          final t = c2.myStatus?.sumWithoutHp() ?? 0;
          final v = c1.myStatus?.sumWithoutHp() ?? 0;
          return t.compareTo(v);
        });
        break;
    }
  }
}
