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
      loading: (String? errMsg) => OnViewLoading(
        title: RSStrings.charactersPageTitle,
        errorMessage: errMsg,
      ),
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
          actions: <Widget>[
            _TitlePopupMenu(
              initType: ref.watch(charactersViewModelProvider).selectedOrderType,
              onSelected: (value) async {
                await ref.read(charactersViewModelProvider).selectOrder(value);
              },
            ),
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
            _ViewList(
              characters: ref.watch(charactersViewModelProvider).statusUpCharacters,
              onRefresh: () async {
                await ref.read(charactersViewModelProvider).refresh();
              },
            ),
            _ViewList(
              characters: ref.watch(charactersViewModelProvider).forHighLevelCharacters,
              onRefresh: () async {
                await ref.read(charactersViewModelProvider).refresh();
              },
            ),
            _ViewList(
              characters: ref.watch(charactersViewModelProvider).forRoundCharacters,
              onRefresh: () async {
                await ref.read(charactersViewModelProvider).refresh();
              },
            ),
            _ViewList(
              characters: ref.watch(charactersViewModelProvider).favoriteCharacters,
              onRefresh: () async {
                await ref.read(charactersViewModelProvider).refresh();
              },
            ),
            _ViewList(
              characters: ref.watch(charactersViewModelProvider).notFavoriteCharacters,
              onRefresh: () async {
                await ref.read(charactersViewModelProvider).refresh();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TitlePopupMenu extends StatelessWidget {
  const _TitlePopupMenu({Key? key, required this.initType, required this.onSelected}) : super(key: key);

  final CharacterListOrderType initType;
  final Function(CharacterListOrderType) onSelected;

  @override
  Widget build(BuildContext context) {
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
      onSelected: onSelected,
    );
  }
}

class _ViewList extends StatelessWidget {
  const _ViewList({Key? key, required this.characters, required this.onRefresh}) : super(key: key);

  final List<Character> characters;
  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const _ViewEmptyList();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return RowCharacterItem(characters[index], refreshListener: onRefresh);
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
