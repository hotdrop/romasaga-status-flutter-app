import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'char_list_row_item.dart';
import 'char_list_view_model.dart';

import '../../common/rs_strings.dart';

class CharListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(centerTitle: true, title: const Text(RSStrings.characterListTabTitle)),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadErrorView() {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(RSStrings.characterListTabTitle)),
      body: Center(
        child: Text(RSStrings.characterListLoadingErrorMessage),
      ),
    );
  }

  Widget _loadSuccessView(CharListViewModel viewModel) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(RSStrings.characterListTabTitle),
          actions: <Widget>[
            _titlePopupMenu(),
          ],
          bottom: const TabBar(tabs: <Tab>[
            Tab(text: RSStrings.characterListTabFavoriteTitle),
            Tab(text: RSStrings.characterListTabPossessionTitle),
            Tab(text: RSStrings.characterListTabUnownedTitle),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            _favoriteTab(viewModel),
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
              child: Text(RSStrings.characterListOrderStatus),
            ),
            PopupMenuItem(
              value: OrderType.weapon,
              child: Text(RSStrings.characterListOrderWeapon),
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
        children: <Widget>[Text(RSStrings.nothingCharacterFavoriteMessage)],
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
        children: <Widget>[Text(RSStrings.nothingCharacterPossessionMessage)],
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