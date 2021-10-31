import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/characters/char_list_row_item.dart';
import 'package:rsapp/ui/characters/characters_view_model.dart';
import 'package:rsapp/ui/widget/rs_dialog.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.charactersPageTitle),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(charactersViewModelProvider).uiState;
          return uiState.when(
            loading: (String? errMsg) => _onLoading(context, errMsg),
            success: () => _onSuccess(context),
          );
        },
      ),
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) {
      AppDialog.onlyOk(message: errMsg!).show(context);
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context) {
    final statusUpCnt = context.read(charactersViewModelProvider).countStatusUpCharacters;
    final favoriteCnt = context.read(charactersViewModelProvider).countFavoriteCharacters;
    final otherCnt = context.read(charactersViewModelProvider).countNotFavoriteCharacters;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(RSStrings.charactersPageTitle),
          actions: <Widget>[
            _titlePopupMenu(context),
          ],
          bottom: TabBar(tabs: <Tab>[
            Tab(text: '${RSStrings.charactersPageTabStatusUp}($statusUpCnt)'),
            Tab(text: '${RSStrings.charactersPageTabFavorite}($favoriteCnt)'),
            Tab(text: '${RSStrings.charactersPageTabNotFavorite}($otherCnt)'),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            _statusUpEventTab(context),
            _favoriteTab(context),
            _notFavoriteTab(context),
          ],
        ),
      ),
    );
  }

  Widget _titlePopupMenu(BuildContext context) {
    final viewModel = context.read(charactersViewModelProvider);

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
      initialValue: viewModel.selectedOrderType,
      onSelected: (value) {
        viewModel.selectOrder(value);
      },
    );
  }

  Widget _statusUpEventTab(BuildContext context) {
    final characters = context.read(charactersViewModelProvider).statusUpCharacters;
    if (characters.isEmpty) {
      return _viewEmptyList();
    }
    return ListView.builder(itemBuilder: (context, index) {
      return CharListRowItem(
        characters[index],
        refreshListener: () async => await context.read(charactersViewModelProvider).refresh(),
      );
    });
  }

  Widget _favoriteTab(BuildContext context) {
    final characters = context.read(charactersViewModelProvider).favoriteCharacters;
    if (characters.isEmpty) {
      return _viewEmptyList();
    }
    return ListView.builder(itemBuilder: (context, index) {
      return CharListRowItem(
        characters[index],
        refreshListener: () async => await context.read(charactersViewModelProvider).refresh(),
      );
    });
  }

  Widget _notFavoriteTab(BuildContext context) {
    final characters = context.read(charactersViewModelProvider).notFavoriteCharacters;
    if (characters.isEmpty) {
      return _viewEmptyList();
    }
    return ListView.builder(itemBuilder: (context, index) {
      return CharListRowItem(
        characters[index],
        refreshListener: () async => await context.read(charactersViewModelProvider).refresh(),
      );
    });
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
