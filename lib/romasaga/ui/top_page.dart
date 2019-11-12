import 'package:flutter/material.dart';

import 'characters/char_list_tab.dart';

import 'search/search_page.dart';
import 'letter/letter_page.dart';
import 'account/account_page.dart';

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
            backgroundColor: RSColors.bottomNavigationBackground,
          );
        }).toList(),
        onTap: (index) {
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
        return SearchPage();
      case 2:
        return LetterPage();
      case 3:
        return AccountPage();
      default:
        return null;
    }
  }
}

class Destination {
  const Destination(this.title, this.icon);
  final String title;
  final IconData icon;
}

const _allDestinations = <Destination>[
  Destination(RSStrings.bottomMenuCharacter, Icons.view_list),
  Destination(RSStrings.bottomMenuSearch, Icons.search),
  Destination(RSStrings.bottomMenuLetter, Icons.mail),
  Destination(RSStrings.bottomMenuAccount, Icons.person),
];
