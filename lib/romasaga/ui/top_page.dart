import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'characters/char_list_page.dart';

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
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        items: _bottomNavigationItems,
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
    );
  }

  Widget _menuView(int index) {
    switch (index) {
      case 0:
        return CharListPage();
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

List<BottomNavyBarItem> _bottomNavigationItems = [
  BottomNavyBarItem(
    title: Text(RSStrings.bottomMenuCharacter),
    icon: Icon(Icons.view_list),
    activeColor: RSColors.bottomNavyCharacter,
  ),
  BottomNavyBarItem(
    title: Text(RSStrings.bottomMenuSearch),
    icon: Icon(Icons.search),
    activeColor: RSColors.bottomNavySearch,
  ),
  BottomNavyBarItem(
    title: Text(RSStrings.bottomMenuLetter),
    icon: Icon(Icons.mail),
    activeColor: RSColors.bottomNavyLetter,
  ),
  BottomNavyBarItem(
    title: Text(RSStrings.bottomMenuAccount),
    icon: Icon(Icons.person),
    activeColor: RSColors.bottomNavyAccount,
  ),
];
