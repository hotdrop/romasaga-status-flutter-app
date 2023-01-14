import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rsapp/res/rs_images.dart';
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
            if (imagePath == null) _ErrorIcon(),
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
      placeholder: (context, url) => const _LoadingIcon(),
      errorWidget: (context, url, dynamic error) => const _ErrorIcon(),
    );
  }
}

class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(RSImages.gifLoading),
        const Padding(padding: EdgeInsets.only(top: 8), child: Text(RSStrings.nowLoading)),
      ],
    );
  }
}

class _ErrorIcon extends StatelessWidget {
  const _ErrorIcon();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(RSImages.gifLoading),
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
