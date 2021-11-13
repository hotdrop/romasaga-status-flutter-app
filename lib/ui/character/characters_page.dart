import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/widget/row_character.dart';
import 'package:rsapp/ui/character/characters_view_model.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';

class CharactersPage extends ConsumerWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(charactersViewModelProvider).uiState;
    return uiState.when(
      loading: (String? errMsg) => _onLoading(context, errMsg),
      success: () => _onSuccess(context, ref),
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errMsg != null) {
        await AppDialog.onlyOk(message: errMsg).show(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.charactersPageTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final statusUpCnt = ref.watch(charactersViewModelProvider).countStatusUpCharacters;
    final favoriteCnt = ref.watch(charactersViewModelProvider).countFavoriteCharacters;
    final otherCnt = ref.watch(charactersViewModelProvider).countNotFavoriteCharacters;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.charactersPageTitle),
          actions: <Widget>[
            _titlePopupMenu(ref),
          ],
          bottom: TabBar(tabs: <Tab>[
            Tab(text: '${RSStrings.charactersPageTabStatusUp}($statusUpCnt)'),
            Tab(text: '${RSStrings.charactersPageTabFavorite}($favoriteCnt)'),
            Tab(text: '${RSStrings.charactersPageTabNotFavorite}($otherCnt)'),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            _statusUpEventTab(ref),
            _favoriteTab(ref),
            _notFavoriteTab(ref),
          ],
        ),
      ),
    );
  }

  Widget _titlePopupMenu(WidgetRef ref) {
    return PopupMenuButton<CharacterListOrderType>(
      padding: EdgeInsets.zero,
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: CharacterListOrderType.status,
          child: Text(RSStrings.charactersOrderStatus),
        ),
        const PopupMenuItem(
          value: CharacterListOrderType.hp,
          child: Text(RSStrings.charactersOrderHp),
        ),
        const PopupMenuItem(
          value: CharacterListOrderType.production,
          child: Text(RSStrings.charactersOrderProduction),
        ),
      ],
      initialValue: ref.watch(charactersViewModelProvider).selectedOrderType,
      onSelected: (value) async {
        await ref.read(charactersViewModelProvider).selectOrder(value);
      },
    );
  }

  Widget _statusUpEventTab(WidgetRef ref) {
    final characters = ref.watch(charactersViewModelProvider).statusUpCharacters;
    return _viewList(characters, ref);
  }

  Widget _favoriteTab(WidgetRef ref) {
    final characters = ref.watch(charactersViewModelProvider).favoriteCharacters;
    return _viewList(characters, ref);
  }

  Widget _notFavoriteTab(WidgetRef ref) {
    final characters = ref.watch(charactersViewModelProvider).notFavoriteCharacters;
    return _viewList(characters, ref);
  }

  Widget _viewList(List<Character> characters, WidgetRef ref) {
    if (characters.isEmpty) {
      return _viewEmptyList();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return RowCharacterItem(characters[index], refreshListener: () async {
          await ref.read(charactersViewModelProvider).refresh();
        });
      },
    );
  }

  Widget _viewEmptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(RSStrings.nothingCharactersLabel),
        ),
      ],
    );
  }
}
