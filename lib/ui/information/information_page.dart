import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/information/letter/letter_page.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.infoPageTitle),
      ),
      body: _onSuccess(context),
    );
  }

  Widget _onSuccess(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              launch(RSStrings.infoOfficialUrl);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(RSStrings.infoOfficialButton),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await LetterPage.start(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(RSStrings.letterPageTitle),
            ),
          ),
        ],
      ),
    );
  }
}
