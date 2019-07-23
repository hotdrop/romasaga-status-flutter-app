import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        child: Center(child: _menuView(_currentIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _allDestinations.map((destination) {
          return BottomNavigationBarItem(
            title: Text(destination.title),
            icon: Icon(destination.icon),
            backgroundColor: destination.color,
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('未実装')],
        );
      case 3:
        return LetterTab();
    }
  }
}

class Destination {
  final String title;
  final IconData icon;
  final Color color;
  const Destination(this.title, this.icon, this.color);
}

const _allDestinations = <Destination>[
  // TODO 色もうちょっと考えたい
  Destination('Char', Icons.person, Colors.black12),
  Destination('Search', Icons.search, Colors.black12),
  Destination('Setting', Icons.settings, Colors.black12),
  Destination('Letter', Icons.mail, Colors.black12),
];
