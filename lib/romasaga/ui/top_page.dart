import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'char_list_tab.dart';
import 'letter/letter_tab.dart';

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
      bottomNavigationBar: FancyBottomNavigation(
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
          }),
    );
  }

  Widget _showBottomMenu(int index) {
    switch (index) {
      case 0:
        return CharListTab();
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
