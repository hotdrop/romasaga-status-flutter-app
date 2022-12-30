import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';

final charactersViewModelProvider = StateNotifierProvider.autoDispose<_CharactersViewModel, AsyncValue<void>>((ref) {
  return _CharactersViewModel(ref);
});

class _CharactersViewModel extends StateNotifier<AsyncValue<void>> {
  _CharactersViewModel(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref _ref;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (_ref.read(characterSNProvider).isEmpty) {
        await _ref.read(characterSNProvider.notifier).refresh();
      }
    });
  }

  Future<void> refresh() async {
    await _ref.read(characterSNProvider.notifier).refresh();
  }

  Future<void> selectOrder(CharacterListOrderType type) async {
    await _ref.read(appSettingsProvider.notifier).setCharacterListOrder(type);
  }
}

// ステータス上昇（育成期間）キャラ一覧
final charactersStatusUpStateProvider = Provider((ref) {
  final c = ref.watch(characterSNProvider).where((c) => c.statusUpEvent).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// 高難易度キャラ一覧
final charactersHighLevelStateProvider = Provider((ref) {
  final c = ref.watch(characterSNProvider).where((c) => (c.myStatus?.favorite ?? false) && (c.myStatus?.useHighLevel ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// 周回キャラ一覧
final charactersForRoundStateProvider = Provider((ref) {
  final c = ref.watch(characterSNProvider).where((c) => (c.myStatus?.favorite ?? false) && !(c.myStatus?.useHighLevel ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// お気に入りキャラ一覧
final charactersFavoriteStateProvider = Provider((ref) {
  final c = ref.watch(characterSNProvider).where((c) => c.myStatus?.favorite ?? false).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// お気に入りでないキャラ一覧
final charactersNotFavoriteStateProvider = Provider((ref) {
  final c = ref.watch(characterSNProvider).where((c) => !(c.myStatus?.favorite ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});
