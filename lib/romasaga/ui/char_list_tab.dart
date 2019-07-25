import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'char_list_row_item.dart';
import 'char_list_view_model.dart';

class CharListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CharListViewModel>(
      builder: (context, viewModel, child) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('キャラクター一覧'),
              bottom: TabBar(tabs: <Tab>[
                Tab(text: 'お気に入り'),
                Tab(text: '所持'),
                Tab(text: '未所持'),
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
      },
    );
  }

  Widget _favoriteTab(CharListViewModel viewModel) {
    final characters = viewModel.findFavorite();

    if (characters.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('お気に入りキャラは設定されていません。')],
      );
    }

    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      if (index < characters.length) {
        return CharListRowItem(
          character: characters[index],
        );
      }
      return null;
    });
  }

  Widget _haveCharTab(CharListViewModel viewModel) {
    final characters = viewModel.findHaveCharacter();

    if (characters.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('持っているキャラはいません。')],
      );
    }

    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      final characters = viewModel.findHaveCharacter();

      if (index < characters.length) {
        return CharListRowItem(
          character: characters[index],
        );
      }
      return null;
    });
  }

  Widget _notHaveCharTab(CharListViewModel viewModel) {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      final characters = viewModel.findNotHaveCharacter();

      if (index < characters.length) {
        return CharListRowItem(
          character: characters[index],
        );
      }
      return null;
    });
  }
}
