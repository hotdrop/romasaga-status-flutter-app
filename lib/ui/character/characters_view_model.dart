import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';

final charactersViewModelProvider = StateNotifierProvider.autoDispose<_CharactersViewModel, AsyncValue<void>>((ref) {
  return _CharactersViewModel(ref.read);
});

class _CharactersViewModel extends StateNotifier<AsyncValue<void>> {
  _CharactersViewModel(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (_read(characterNotifierProvider).isEmpty) {
        await _read(characterNotifierProvider.notifier).refresh();
      }
    });
  }

  Future<void> refresh() async {
    await _read(characterNotifierProvider.notifier).refresh();
  }

  Future<void> selectOrder(CharacterListOrderType type) async {
    await _read(appSettingsProvider.notifier).setCharacterListOrder(type);
  }

  static List<Character> order(List<Character> c, CharacterListOrderType orderType) {
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
  }
}

// ステータス上昇（育成期間）キャラ一覧
final charactersStatusUpStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider).where((c) => c.statusUpEvent).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return _CharactersViewModel.order(c, orderType);
});

// 高難易度キャラ一覧
final charactersHighLevelStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider).where((c) => (c.myStatus?.favorite ?? false) && (c.myStatus?.useHighLevel ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return _CharactersViewModel.order(c, orderType);
});

// 周回キャラ一覧
final charactersForRoundStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider).where((c) => (c.myStatus?.favorite ?? false) && !(c.myStatus?.useHighLevel ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return _CharactersViewModel.order(c, orderType);
});

// お気に入りキャラ一覧
final charactersFavoriteStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider).where((c) => c.myStatus?.favorite ?? false).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return _CharactersViewModel.order(c, orderType);
});

// お気に入りでないキャラ一覧
final charactersNotFavoriteStateProvider = StateProvider((ref) {
  final c = ref.watch(characterNotifierProvider).where((c) => !(c.myStatus?.favorite ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return _CharactersViewModel.order(c, orderType);
});
