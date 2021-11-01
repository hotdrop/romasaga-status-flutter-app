import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/account/account_page.dart';
import 'package:rsapp/ui/character/characters_page.dart';
import 'package:rsapp/ui/information/information_page.dart';
import 'package:rsapp/ui/search/search_page.dart';

class TopPage extends StatefulWidget {
  const TopPage._();

  static Future<void> start(BuildContext context) async {
    Navigator.popUntil(context, (route) => route.isFirst);
    await Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const TopPage._(),
      ),
    );
  }

  static const String routeName = '/top';

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _menuView(_currentIndex)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 16.0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        items: _allDestinations.map((destination) {
          return BottomNavigationBarItem(
            label: destination.title,
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

  Widget? _menuView(int index) {
    switch (index) {
      case 0:
        return const CharactersPage();
      case 1:
        return const SearchPage();
      case 2:
        return const InformationPage();
      case 3:
        return const AccountPage();
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
  Destination(RSStrings.bottomMenuInformation, Icons.info),
  Destination(RSStrings.bottomMenuAccount, Icons.person),
];
