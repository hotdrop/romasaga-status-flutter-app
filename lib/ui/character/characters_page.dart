import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:rsapp/ui/widget/row_character.dart';
import 'package:rsapp/ui/character/characters_view_model.dart';

class CharactersPage extends ConsumerWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(charactersViewModelProvider).uiState;
    return uiState.when(
      loading: (String? errMsg) => OnViewLoading(title: RSStrings.charactersPageTitle, errorMessage: errMsg),
      success: () => _onSuccess(context, ref),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final statusUpCnt = ref.watch(charactersViewModelProvider).countStatusUpCharacters;
    final highLevelCount = ref.watch(charactersViewModelProvider).countForHighLevelCharacters;
    final roundCount = ref.watch(charactersViewModelProvider).countForRoundCharacters;
    final favoriteCnt = ref.watch(charactersViewModelProvider).countFavoriteCharacters;
    final otherCnt = ref.watch(charactersViewModelProvider).countNotFavoriteCharacters;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.charactersPageTitle),
          actions: const <Widget>[
            _TitlePopupMenu(),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: <Tab>[
              Tab(text: '${RSStrings.charactersPageTabStatusUp}($statusUpCnt)'),
              Tab(text: '${RSStrings.charactersPageTabHighLevel}($highLevelCount)'),
              Tab(text: '${RSStrings.charactersPageTabAround}($roundCount)'),
              Tab(text: '${RSStrings.charactersPageTabFavorite}($favoriteCnt)'),
              Tab(text: '${RSStrings.charactersPageTabNotFavorite}($otherCnt)'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _ViewList(characters: ref.watch(charactersViewModelProvider).statusUpCharacters),
            _ViewList(characters: ref.watch(charactersViewModelProvider).forHighLevelCharacters),
            _ViewList(characters: ref.watch(charactersViewModelProvider).forRoundCharacters),
            _ViewList(characters: ref.watch(charactersViewModelProvider).favoriteCharacters),
            _ViewList(characters: ref.watch(charactersViewModelProvider).notFavoriteCharacters),
          ],
        ),
      ),
    );
  }
}

class _TitlePopupMenu extends ConsumerWidget {
  const _TitlePopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initType = ref.watch(charactersViewModelProvider).selectedOrderType;

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
      initialValue: initType,
      onSelected: (value) async {
        await ref.read(charactersViewModelProvider).selectOrder(value);
      },
    );
  }
}

class _ViewList extends ConsumerWidget {
  const _ViewList({Key? key, required this.characters}) : super(key: key);

  final List<Character> characters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (characters.isEmpty) {
      return const _ViewEmptyList();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return RowCharacterItem(
          characters[index],
          refreshListener: () async {
            await ref.read(charactersViewModelProvider).refresh();
          },
        );
      },
    );
  }
}

class _ViewEmptyList extends StatelessWidget {
  const _ViewEmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
