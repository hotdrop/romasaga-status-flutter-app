import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.letterPageTitle),
      ),
      body: const Center(child: Text('未実装')),
    );
  }
}