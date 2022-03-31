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
      loading: (String? errMsg) {
        return OnViewLoading(title: RSStrings.charactersPageTitle, errorMessage: errMsg);
      },
      success: () {
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
                  Tab(text: '${RSStrings.charactersPageTabStatusUp}(${ref.watch(charactersStatusUpStateProvider).length})'),
                  Tab(text: '${RSStrings.charactersPageTabHighLevel}(${ref.watch(charactersHighLevelStateProvider).length})'),
                  Tab(text: '${RSStrings.charactersPageTabAround}(${ref.watch(charactersForRoundStateProvider).length})'),
                  Tab(text: '${RSStrings.charactersPageTabFavorite}(${ref.watch(charactersFavoriteStateProvider).length})'),
                  Tab(text: '${RSStrings.charactersPageTabNotFavorite}(${ref.watch(charactersNotFavoriteStateProvider).length})'),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                _ViewList(characters: ref.watch(charactersStatusUpStateProvider)),
                _ViewList(characters: ref.watch(charactersHighLevelStateProvider)),
                _ViewList(characters: ref.watch(charactersForRoundStateProvider)),
                _ViewList(characters: ref.watch(charactersFavoriteStateProvider)),
                _ViewList(characters: ref.watch(charactersNotFavoriteStateProvider)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TitlePopupMenu extends ConsumerWidget {
  const _TitlePopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      initialValue: ref.watch(appSettingsProvider).characterListOrderType,
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
            // ここ全部更新しないでcharacters[index]だけ更新すればいい
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
