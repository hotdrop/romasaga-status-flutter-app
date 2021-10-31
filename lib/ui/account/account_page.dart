import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.accountPageTitle),
      ),
      body: const Center(child: Text('未実装')),
    );
  }
}
