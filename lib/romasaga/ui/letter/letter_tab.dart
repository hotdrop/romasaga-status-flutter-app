import 'package:flutter/material.dart';

import 'letter_main_page.dart';
import '../../model/letter.dart';

import '../../common/strings.dart';

class LetterTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.LetterTabTitle),
      ),
      body: Center(
        child: _widgetContents(context),
      ),
    );
  }

  Widget _widgetContents(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _widgetLetterButtons(context),
    );
  }

  List<Widget> _widgetLetterButtons(BuildContext context) {
    var letterButtons = <Widget>[];
    for (var type in LetterType.values) {
      letterButtons.add(_letterButton(context, type));
      letterButtons.add(const SizedBox(height: 16.0));
    }
    return letterButtons;
  }

  Widget _letterButton(BuildContext context, LetterType letterType) {
    final letter = Letter.fromType(letterType);
    return OutlineButton(
      textColor: letter.themeColor,
      borderSide: BorderSide(color: letter.themeColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LetterMainPage(letterType)),
        );
      },
      child: Text(letter.title),
    );
  }
}
