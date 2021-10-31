import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.searchPageTitle),
      ),
      body: const Center(child: Text('未実装')),
    );
  }
}
