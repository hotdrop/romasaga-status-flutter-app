import 'package:flutter/material.dart';

import '../../model/letter.dart';
import '../../common/strings.dart';

class LetterMainPage extends StatelessWidget {
  final LetterType firstSelectLetterType;

  const LetterMainPage({@required this.firstSelectLetterType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Strings.LetterPageTitle),
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
  final Letter letter;

  const _LetterDetailPage(this.letter);

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
        Shadow(color: Colors.grey, offset: Offset(1, 2), blurRadius: 2),
      ]),
    );
  }

  Widget _widgetImageGif() {
    return Image.asset(letter.gifResource);
  }
}
