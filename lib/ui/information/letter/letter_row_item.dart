import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/ui/information/letter/letter_detail_page.dart';

class LetterRowItem extends StatelessWidget {
  const LetterRowItem(
    this._selectedIndex,
    this._allLetters, {
    Key? key,
  }) : super(key: key);

  final int _selectedIndex;
  final List<Letter> _allLetters;

  @override
  Widget build(BuildContext context) {
    final currentLetter = _allLetters[_selectedIndex];
    return Card(
      child: InkWell(
        child: Column(
          children: <Widget>[
            _viewImage(context, currentLetter),
            _viewImageTitle(context, currentLetter),
          ],
        ),
        onTap: () async {
          await LetterDetailPage.start(context, _selectedIndex, _allLetters);
        },
      ),
    );
  }

  Widget _viewImage(BuildContext context, Letter letter) {
    final imagePath = letter.staticImagePath;
    if (imagePath != null) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.fill,
        placeholder: (context, url) => _loadingIcon(letter.loadingIcon),
        errorWidget: (context, url, dynamic error) => _errorIcon(letter.loadingIcon),
      );
    } else {
      return _errorIcon(letter.loadingIcon);
    }
  }

  Widget _loadingIcon(String res) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(res),
        const Padding(padding: EdgeInsets.only(top: 8), child: Text(RSStrings.letterNowLoading)),
      ],
    );
  }

  Widget _errorIcon(String res) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(res),
        const SizedBox(height: 8),
        const Text(RSStrings.letterLoadingFailure, style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _viewImageTitle(BuildContext context, Letter letter) {
    return Text(
      '${letter.month}${RSStrings.letterMonthLabel} ${letter.shortTitle}',
      style: TextStyle(color: letter.themeColor),
    );
  }
}
