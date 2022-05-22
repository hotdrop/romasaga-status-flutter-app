import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/ui/information/letter/letter_detail_page.dart';

class LetterRowItem extends StatelessWidget {
  const LetterRowItem(this._selectedIndex, this._allLetters, {super.key});

  final int _selectedIndex;
  final List<Letter> _allLetters;

  @override
  Widget build(BuildContext context) {
    final currentLetter = _allLetters[_selectedIndex];
    final imagePath = currentLetter.staticImagePath;

    return Card(
      child: InkWell(
        child: Column(
          children: <Widget>[
            if (imagePath != null) _ViewImage(imagePath: imagePath, letter: currentLetter),
            if (imagePath == null) _ErrorIcon(res: currentLetter.loadingIcon),
            _ViewImageTitle(letter: currentLetter),
          ],
        ),
        onTap: () async {
          await LetterDetailPage.start(context, _selectedIndex, _allLetters);
        },
      ),
    );
  }
}

class _ViewImage extends StatelessWidget {
  const _ViewImage({required this.imagePath, required this.letter});

  final String imagePath;
  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      fit: BoxFit.fill,
      placeholder: (context, url) => _LoadingIcon(res: letter.loadingIcon),
      errorWidget: (context, url, dynamic error) => _ErrorIcon(res: letter.loadingIcon),
    );
  }
}

class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon({required this.res});

  final String res;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(res),
        const Padding(padding: EdgeInsets.only(top: 8), child: Text(RSStrings.letterNowLoading)),
      ],
    );
  }
}

class _ErrorIcon extends StatelessWidget {
  const _ErrorIcon({required this.res});

  final String res;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(res),
        const SizedBox(height: 8),
        const Text(RSStrings.letterLoadingFailure, style: TextStyle(color: Colors.red)),
      ],
    );
  }
}

class _ViewImageTitle extends StatelessWidget {
  const _ViewImageTitle({required this.letter});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${letter.month}${RSStrings.letterMonthLabel} ${letter.shortTitle}',
      style: TextStyle(color: letter.themeColor),
    );
  }
}
