import 'package:flutter/material.dart';

import 'letter_main_page.dart';
import '../../model/letter.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

class LetterTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(RSStrings.letterTabTitle),
        ),
      ),
      body: _widgetContents(context),
    );
  }

  Widget _widgetContents(BuildContext context) {
    // GridViewはアスペクト比が1:1になってしまうため個別指定している。
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 7 / 10,
      scrollDirection: Axis.vertical,
      children: _widgetLetters(context),
    );
  }

  List<Widget> _widgetLetters(BuildContext context) {
    final letterButtons = <Widget>[];
    for (final type in LetterType.values) {
      final letter = Letter.fromType(type);
      letterButtons.add(_cardLetter(context, letter));
    }
    return letterButtons;
  }

  Widget _cardLetter(BuildContext context, Letter letter) {
    return Card(
      color: RSColors.thumbnailCardBackground,
      child: InkWell(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 250,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.asset(letter.thumbnail, fit: BoxFit.fill),
                  ),
                ],
              ),
            ),
            Text(letter.shortTitle, style: TextStyle(color: letter.themeColor)),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LetterMainPage(firstSelectLetterType: letter.type)),
          );
        },
      ),
    );
  }
}
