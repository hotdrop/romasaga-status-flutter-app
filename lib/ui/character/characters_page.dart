import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/widget/row_character.dart';
import 'package:rsapp/ui/character/characters_providers.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class CharactersPage extends ConsumerWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.charactersPageTitle),
          actions: const [_TitlePopupMenu()],
          bottom: TabBar(
            isScrollable: true,
            tabs: <Tab>[
              Tab(icon: TabIcon.statusUp(count: ref.watch(charactersStatusUpProvider).length)),
              Tab(icon: TabIcon.highLevel(count: ref.watch(charactersHighLevelProvider).length)),
              Tab(icon: TabIcon.around(count: ref.watch(charactersForRoundProvider).length)),
              Tab(icon: TabIcon.favorite(isSelected: true, count: ref.watch(charactersFavoriterovider).length)),
              Tab(icon: TabIcon.favorite(isSelected: false, count: ref.watch(charactersNotFavoriteProvider).length)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ViewList(characters: ref.watch(charactersStatusUpProvider)),
            _ViewList(characters: ref.watch(charactersHighLevelProvider)),
            _ViewList(characters: ref.watch(charactersForRoundProvider)),
            _ViewList(characters: ref.watch(charactersFavoriterovider)),
            _ViewList(characters: ref.watch(charactersNotFavoriteProvider)),
          ],
        ),
      ),
    );
  }
}

class _TitlePopupMenu extends ConsumerWidget {
  const _TitlePopupMenu();

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
      initialValue: ref.read(appSettingsProvider).characterListOrderType,
      onSelected: (value) async {
        await ref.read(charactersControllerProvider.notifier).selectOrder(value);
      },
    );
  }
}

class _ViewList extends ConsumerWidget {
  const _ViewList({required this.characters});

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
        return RowCharacterItem(characters[index]);
      },
    );
  }
}

class _ViewEmptyList extends StatelessWidget {
  const _ViewEmptyList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(RSStrings.nothingCharactersLabel),
        ),
      ],
    );
  }
}
