import 'package:flutter/material.dart';
import 'package:side_header_list_view/side_header_list_view.dart';

import 'letter_detail_page.dart';
import '../widget/custom_page_route.dart';
import '../../model/letter.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

class LetterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(RSStrings.letterPageTitle),
        ),
      ),
      body: _widgetContents(context),
    );
  }

  Widget _widgetContents(BuildContext context) {
    final List<Letter> items = LetterType.values.map((type) => Letter.fromType(type)).toList();
    return SideHeaderListView(
      itemCount: items.length,
      itemExtend: 430.0,
      headerBuilder: (context, index) => _createHeader(items[index]),
      itemBuilder: (context, index) => _createCardLetter(context, items[index]),
      hasSameHeader: (headerIndex, itemIndex) => items[headerIndex].year == items[itemIndex].year,
    );
  }

  Widget _createHeader(Letter letter) {
    return Center(
      child: Text("${letter.year}年"),
    );
  }

  Widget _createCardLetter(BuildContext context, Letter letter) {
    return Card(
      color: RSColors.thumbnailCardBackground,
      child: InkWell(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 400,
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
          Navigator.push<void>(
            context,
            ScalePageRoute(page: LetterMainPage(firstSelectLetterType: letter.type)),
          );
        },
      ),
    );
  }
}
