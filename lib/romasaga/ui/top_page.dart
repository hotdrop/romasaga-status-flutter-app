import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'char_list_tab.dart';
import 'search/search_list_tab.dart';
import 'letter/letter_tab.dart';

import 'char_list_view_model.dart';

class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: _showBottomMenu(_currentIndex)),
      ),
      bottomNavigationBar: _fancyBottomNavigation(),
    );
  }

  Widget _fancyBottomNavigation() {
    return FancyBottomNavigation(
      tabs: [
        TabData(iconData: Icons.person, title: 'Char'),
        TabData(iconData: Icons.search, title: 'Search'),
        TabData(iconData: Icons.settings, title: 'Setting'),
        TabData(iconData: Icons.mail, title: 'Letter')
      ],
      initialSelection: 0,
      circleColor: Colors.white30,
      onTabChangedListener: (position) {
        setState(() {
          _currentIndex = position;
        });
      },
    );
  }

  Widget _showBottomMenu(int index) {
    switch (index) {
      case 0:
        return CharListTab();
      case 1:
        return Consumer<CharListViewModel>(builder: (_, viewModel, child) {
          return SearchListTab(viewModel.findAll());
        });
      // TODO case 2: 設定画面作成予定
      case 3:
        return LetterTab();
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('未実装')],
        );
    }
  }
}
