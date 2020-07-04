import 'package:flutter/material.dart';
import 'package:rsapp/romasaga/ui/characters/char_list_page.dart';
import 'package:rsapp/romasaga/ui/search/search_page.dart';
import 'package:rsapp/romasaga/ui/letter/letter_page.dart';
import 'package:rsapp/romasaga/ui/account/account_page.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';

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
        elevation: 16.0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        items: _allDestinations.map((destination) {
          return BottomNavigationBarItem(
            title: Text(destination.title),
            icon: Icon(destination.icon),
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
