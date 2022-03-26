import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/ui/base_view_model.dart';

final charactersViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CharactersViewModel(ref.read));

// ステータス上昇（育成期間）キャラ一覧
final charactersStatusUpStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider);
  final cFilter = c.where((c) => c.statusUpEvent).toList();
  return ref.read(_charactersOrderProvider(cFilter));
});

// 高難易度キャラ一覧
final charactersHighLevelStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider);
  final cFilter = c.where((c) => (c.myStatus?.favorite ?? false) && (c.myStatus?.useHighLevel ?? false)).toList();
  return ref.read(_charactersOrderProvider(cFilter));
});

// 周回キャラ一覧
final charactersForRoundStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider);
  final cFilter = c.where((c) => (c.myStatus?.favorite ?? false) && !(c.myStatus?.useHighLevel ?? false)).toList();
  return ref.read(_charactersOrderProvider(cFilter));
});

// お気に入りキャラ一覧
final charactersFavoriteStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider);
  final cFilter = c.where((c) => c.myStatus?.favorite ?? false).toList();
  return ref.read(_charactersOrderProvider(cFilter));
});

// お気に入りでないキャラ一覧
final charactersNotFavoriteStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider);
  final cFilter = c.where((c) => !(c.myStatus?.favorite ?? false)).toList();
  return ref.read(_charactersOrderProvider(cFilter));
});

// キャラ一覧の並び順を整える
final _charactersOrderProvider = Provider.family<List<Character>, List<Character>>((ref, characters) {
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  final c = characters;
  switch (orderType) {
    case CharacterListOrderType.hp:
      c.sort((c1, c2) {
        final t = c2.myStatus?.hp ?? 0;
        final v = c1.myStatus?.hp ?? 0;
        return t.compareTo(v);
      });
      break;
    case CharacterListOrderType.production:
      c.sort((c1, c2) => c1.id.compareTo(c2.id));
      break;
    case CharacterListOrderType.status:
      c.sort((c1, c2) {
        final t = c2.myStatus?.sumWithoutHp() ?? 0;
        final v = c1.myStatus?.sumWithoutHp() ?? 0;
        return t.compareTo(v);
      });
      break;
  }
  return c;
});

class _CharactersViewModel extends BaseViewModel {
  _CharactersViewModel(this._read) {
    _init();
  }

  final Reader _read;

  CharacterListOrderType get selectedOrderType => _read(appSettingsProvider).characterListOrderType;

  Future<void> _init() async {
    try {
      final characters = _read(characterNotifierProvider);
      if (characters.isEmpty) {
        await _read(characterNotifierProvider.notifier).refresh();
      }
      onSuccess();
    } catch (e, s) {
      RSLogger.e('キャラ一覧取得でエラー', e, s);
      onError('$e');
    }
  }

  Future<void> refresh() async {
    try {
      await _read(characterNotifierProvider.notifier).refresh();
    } catch (e, s) {
      RSLogger.e('キャラ一覧更新でエラー', e, s);
      onError('$e');
    }
  }

  Future<void> selectOrder(CharacterListOrderType type) async {
    await _read(appSettingsProvider.notifier).setCharacterListOrder(type);
  }
}
