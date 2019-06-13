import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/char_list_view_model.dart';
import 'ui/top_page.dart';

void main() {
  return runApp(ChangeNotifierProvider<CharListViewModel>(
    builder: (context) => CharListViewModel()..load(),
    child: RomasagaApp(),
  ));
}

class RomasagaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Romansing SaGa App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TopPage(),
    );
  }
}
