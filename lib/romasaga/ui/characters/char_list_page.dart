import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/page_state.dart';
import 'package:rsapp/romasaga/ui/characters/char_list_row_item.dart';
import 'package:rsapp/romasaga/ui/characters/char_list_view_model.dart';

class CharListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharListViewModel.create()..load(),
      builder: (context, child) {
        final pageState = context.select<CharListViewModel, PageState>((value) => value.pageState);
        if (pageState.nowLoading()) {
          return _loadingView();
        } else if (pageState.loadSuccess()) {
          return _loadedView(context);
        } else {
          return _loadErrorView();
        }
      },
      child: _loadingView(),
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

  Widget _loadedView(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(RSStrings.characterListPageTitle),
          actions: <Widget>[
            _titlePopupMenu(context),
          ],
          bottom: const TabBar(tabs: <Tab>[
            const Tab(icon: const Icon(Icons.favorite)),
            const Tab(icon: const Icon(Icons.trending_up)),
            const Tab(icon: const Icon(Icons.people)),
            const Tab(icon: const Icon(Icons.people_outline)),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            _favoriteTab(context),
            _statusUpEventTab(context),
            _haveCharTab(context),
            _notHaveCharTab(context),
          ],
        ),
      ),
    );
  }

  Widget _titlePopupMenu(BuildContext context) {
    final viewModel = Provider.of<CharListViewModel>(context);

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
  }

  Widget _favoriteTab(BuildContext context) {
    final viewModel = Provider.of<CharListViewModel>(context);
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
        return CharListRowItem(characters[index], refreshListener: () async {
          await viewModel.refresh();
        });
      }
      return null;
    });
  }

  Widget _statusUpEventTab(BuildContext context) {
    final viewModel = Provider.of<CharListViewModel>(context);
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
        return CharListRowItem(characters[index], refreshListener: () async {
          await viewModel.refresh();
        });
      }
      return null;
    });
  }

  Widget _haveCharTab(BuildContext context) {
    final viewModel = Provider.of<CharListViewModel>(context);
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
        return CharListRowItem(characters[index], refreshListener: () async {
          await viewModel.refresh();
        });
      }
      return null;
    });
  }

  Widget _notHaveCharTab(BuildContext context) {
    final viewModel = Provider.of<CharListViewModel>(context);

    return ListView.builder(itemBuilder: (context, index) {
      final characters = viewModel.findNotHaveCharacter();

      if (index < characters.length) {
        return CharListRowItem(characters[index], refreshListener: () async {
          await viewModel.refresh();
        });
      }
      return null;
    });
  }
}
