import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/ui/characters/char_list_row_item.dart';
import 'package:rsapp/romasaga/ui/characters/char_list_view_model.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';

class CharListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CharListViewModel.create()..load(),
      child: _loadingBody(),
    );
  }

  Widget _loadingBody() {
    return Consumer<CharListViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _loadingView();
        } else if (viewModel.isSuccess) {
          return _loadSuccessView(viewModel);
        } else {
          return _loadErrorView();
        }
      },
    );
  }

  Widget _loadingView() {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(RSStrings.characterListPageTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadErrorView() {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(RSStrings.characterListPageTitle)),
      body: Center(
        child: Text(RSStrings.characterListLoadingErrorMessage),
      ),
    );
  }

  Widget _loadSuccessView(CharListViewModel viewModel) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(RSStrings.characterListPageTitle),
          actions: <Widget>[
            _titlePopupMenu(),
          ],
          bottom: const TabBar(tabs: <Tab>[
            Tab(text: RSStrings.characterListFavoriteTabTitle),
            Tab(text: RSStrings.characterListEventTabTitle),
            Tab(text: RSStrings.characterListPossessionTabTitle),
            Tab(text: RSStrings.characterListNotPossessionTabTitle),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            _favoriteTab(viewModel),
            _statusUpEventTab(viewModel),
            _haveCharTab(viewModel),
            _notHaveCharTab(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _titlePopupMenu() {
    return Consumer<CharListViewModel>(
      builder: (_, viewModel, child) {
        return PopupMenuButton<OrderType>(
          padding: EdgeInsets.zero,
          itemBuilder: (_) => [
            PopupMenuItem(
              value: OrderType.status,
              child: const Text(RSStrings.characterListOrderStatus),
            ),
            PopupMenuItem(
              value: OrderType.hp,
              child: const Text(RSStrings.characterListOrderHp),
            ),
            PopupMenuItem(
              value: OrderType.production,
              child: const Text(RSStrings.characterListOrderProduction),
            ),
          ],
          initialValue: viewModel.selectedOrderType,
          onSelected: (value) {
            viewModel.orderBy(value);
          },
        );
      },
    );
  }

  Widget _favoriteTab(CharListViewModel viewModel) {
    final characters = viewModel.findFavorite();

    if (characters.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(RSStrings.nothingCharacterFavoriteMessage),
          ),
        ],
      );
    }

    return ListView.builder(itemBuilder: (context, index) {
      if (index < characters.length) {
        return CharListRowItem(characters[index]);
      }
      return null;
    });
  }

  Widget _statusUpEventTab(CharListViewModel viewModel) {
    final characters = viewModel.findStatusUpEvent();

    if (characters.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(RSStrings.nothingStatusUpEventCharacterMessage),
          ),
        ],
      );
    }

    return ListView.builder(itemBuilder: (context, index) {
      if (index < characters.length) {
        return CharListRowItem(characters[index]);
      }
      return null;
    });
  }

  Widget _haveCharTab(CharListViewModel viewModel) {
    final characters = viewModel.findHaveCharacter();

    if (characters.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(RSStrings.nothingCharacterPossessionMessage),
          ),
        ],
      );
    }

    return ListView.builder(itemBuilder: (context, index) {
      final characters = viewModel.findHaveCharacter();

      if (index < characters.length) {
        return CharListRowItem(characters[index]);
      }
      return null;
    });
  }

  Widget _notHaveCharTab(CharListViewModel viewModel) {
    return ListView.builder(itemBuilder: (context, index) {
      final characters = viewModel.findNotHaveCharacter();

      if (index < characters.length) {
        return CharListRowItem(characters[index]);
      }
      return null;
    });
  }
}
