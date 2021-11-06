import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/information/letter/letter_page.dart';
import 'package:rsapp/ui/widget/app_button.dart';
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
          AppButton(
            label: RSStrings.infoOfficialButton,
            onTap: () {
              launch(RSStrings.infoOfficialUrl);
            },
          ),
          const SizedBox(height: 16),
          AppButton(
            label: RSStrings.letterPageTitle,
            onTap: () async {
              await LetterPage.start(context);
            },
          ),
        ],
      ),
    );
  }
}
