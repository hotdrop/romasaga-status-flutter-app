import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';

part 'characters_providers.g.dart';

@riverpod
class CharactersController extends _$CharactersController {
  @override
  void build() {}

  Future<void> selectOrder(CharacterListOrderType type) async {
    await ref.read(appSettingsProvider.notifier).setCharacterListOrder(type);
  }
}

// ステータス上昇（育成期間）キャラ一覧
final charactersStatusUpProvider = Provider((ref) {
  final c = ref.watch(characterProvider).where((c) => c.statusUpEvent).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// お気に入りキャラ一覧
final charactersFavoriterovider = Provider((ref) {
  final c = ref.watch(characterProvider).where((c) => c.myStatus?.favorite ?? false).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});

// お気に入りでないキャラ一覧
final charactersNotFavoriteProvider = Provider((ref) {
  final c = ref.watch(characterProvider).where((c) => !(c.myStatus?.favorite ?? false)).toList();
  final orderType = ref.watch(appSettingsProvider).characterListOrderType;
  return c.order(orderType);
});
