import 'package:flutter/material.dart';

import '../../model/letter.dart';

import '../../common/rs_strings.dart';
import '../../common/rs_colors.dart';

class LetterMainPage extends StatelessWidget {
  const LetterMainPage({@required this.firstSelectLetterType});

  final LetterType firstSelectLetterType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(RSStrings.letterPageTitle),
      ),
      body: Center(
        child: _widgetContents(context),
      ),
    );
  }

  Widget _widgetContents(BuildContext context) {
    final controller = PageController(initialPage: firstSelectLetterType.index, keepPage: false);
    return PageView.builder(
        controller: controller,
        itemCount: LetterType.values.length,
        itemBuilder: (context, index) {
          final selectedType = LetterType.values[index];
          return _LetterDetailPage(Letter.fromType(selectedType));
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
      letter.title,
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
    return Image.asset(letter.gifResource);
  }
}
