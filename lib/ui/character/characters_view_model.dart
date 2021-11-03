import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/ui/base_view_model.dart';

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
    await _refreshAllData();
    onSuccess();
  }

  Future<void> refresh() async {
    await _refreshAllData();
    notifyListeners();
  }

  Future<void> _refreshAllData() async {
    try {
      await _read(characterNotifierProvider.notifier).refresh();
      _characters = _read(characterNotifierProvider);
      _selectedOrderType = _read(appSettingsProvider).characterListOrderType;
      _charactersOrderBy(_selectedOrderType);
    } catch (e, s) {
      RSLogger.e('キャラ一覧更新でエラー', e, s);
      onError('$e');
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
