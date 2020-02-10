import 'package:flutter/material.dart';

import '../../model/letter.dart';

import '../../common/rs_strings.dart';
import '../../common/rs_colors.dart';

class LetterMainPage extends StatelessWidget {
  const LetterMainPage({@required this.selectedIndex, @required this.letters});

  final int selectedIndex;
  final List<Letter> letters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(RSStrings.letterDetailPageTitle),
      ),
      body: Center(
        child: _widgetContents(context),
      ),
    );
  }

  Widget _widgetContents(BuildContext context) {
    final controller = PageController(initialPage: selectedIndex, keepPage: false);

    return PageView.builder(
        controller: controller,
        itemCount: letters.length,
        itemBuilder: (context, index) {
          return _LetterDetailPage(letters[index]);
        });
  }
}

class _LetterDetailPage extends StatelessWidget {
  const _LetterDetailPage(this.letter);

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _widgetContents(),
    );
  }

  Widget _widgetContents() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 16.0),
        _widgetTitle(),
        const SizedBox(height: 16.0),
        _widgetImageGif(),
      ],
    );
  }

  Widget _widgetTitle() {
    return Text(
      '${letter.month}${RSStrings.letterMonthLabel} ${letter.title}',
      style: TextStyle(fontSize: 24.0, color: letter.themeColor, shadows: [
        Shadow(
          color: RSColors.titleShadow,
          offset: Offset(1, 2),
          blurRadius: 2,
        ),
      ]),
    );
  }

  Widget _widgetImageGif() {
    return Image.asset(letter.imagePath);
  }
}
