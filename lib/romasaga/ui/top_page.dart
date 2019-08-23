import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'char_list_tab.dart';
import 'search/search_list_tab.dart';
import 'letter/letter_tab.dart';
import 'account/account_tab.dart';

import 'char_list_view_model.dart';

import '../common/rs_colors.dart';
import '../common/rs_strings.dart';

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
        child: Center(child: _menuView(_currentIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _allDestinations.map((destination) {
          return BottomNavigationBarItem(
            title: Text(destination.title),
            icon: Icon(destination.icon),
            backgroundColor: RSColors.bottomNavigationIcon,
          );
        }).toList(),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _menuView(int index) {
    switch (index) {
      case 0:
        return CharListTab();
      case 1:
        return Consumer<CharListViewModel>(builder: (_, viewModel, child) {
          return SearchListTab(viewModel.findAll());
        });
      case 2:
        return LetterTab();
      case 3:
        return Consumer<CharListViewModel>(builder: (_, viewModel, child) {
          return SettingTab(viewModel);
        });
      default:
        return null;
    }
  }
}

class Destination {
  final String title;
  final IconData icon;
  const Destination(this.title, this.icon);
}

const _allDestinations = <Destination>[
  Destination(RSStrings.BottomMenuCharacter, Icons.view_list),
  Destination(RSStrings.BottomMenuSearch, Icons.search),
  Destination(RSStrings.BottomMenuLetter, Icons.mail),
  Destination(RSStrings.BottomMenuAccount, Icons.person),
];
