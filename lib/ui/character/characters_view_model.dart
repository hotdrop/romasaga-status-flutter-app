import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';

part 'characters_view_model.g.dart';

@riverpod
class CharactersViewModel extends _$CharactersViewModel {
  @override
  Future<void> build() async {
    await ref.read(characterProvider.notifier).init();
  }

  Future<void> selectOrder(CharacterListOrderType type) async {
    await ref.read(appSettingsProvider.notifier).setCharacterListOrder(type);
  }
}

// ステータス上昇（育成期間）キャラ一覧
final charactersStatusUpStateProvider = Provider((ref) {
  final c = ref.watch(characterProvider).where((c) => c.statusUpEvent).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// 高難易度キャラ一覧
final charactersHighLevelStateProvider = Provider((ref) {
  final c = ref.watch(characterProvider).where((c) => (c.myStatus?.favorite ?? false) && (c.myStatus?.useHighLevel ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// 周回キャラ一覧
final charactersForRoundStateProvider = Provider((ref) {
  final c = ref.watch(characterProvider).where((c) => (c.myStatus?.favorite ?? false) && !(c.myStatus?.useHighLevel ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// お気に入りキャラ一覧
final charactersFavoriteStateProvider = Provider((ref) {
  final c = ref.watch(characterProvider).where((c) => c.myStatus?.favorite ?? false).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// お気に入りでないキャラ一覧
final charactersNotFavoriteStateProvider = Provider((ref) {
  final c = ref.watch(characterProvider).where((c) => !(c.myStatus?.favorite ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});
