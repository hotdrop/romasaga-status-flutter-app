import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/res/rs_colors.dart';

class LetterDetailPage extends StatelessWidget {
  const LetterDetailPage._(this._selectedIndex, this._letters);

  static Future<void> start(BuildContext context, int index, List<Letter> letters) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => LetterDetailPage._(index, letters)),
    );
  }

  final int _selectedIndex;
  final List<Letter> _letters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.letterDetailPageTitle),
      ),
      body: _viewBody(context),
    );
  }

  Widget _viewBody(BuildContext context) {
    final controller = PageController(initialPage: _selectedIndex, keepPage: false);
    return Center(
      child: PageView.builder(
        controller: controller,
        itemCount: _letters.length,
        itemBuilder: (context, index) => _LetterDetailPage(_letters[index]),
      ),
    );
  }
}

class _LetterDetailPage extends StatelessWidget {
  const _LetterDetailPage(this.letter);

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16),
          _viewTitle(),
          const SizedBox(height: 16),
          _viewGifImage(),
        ],
      ),
    );
  }

  Widget _viewTitle() {
    return Text(
      '${letter.month}${RSStrings.letterMonthLabel} ${letter.title}',
      style: TextStyle(
        fontSize: 24.0,
        color: letter.themeColor,
        shadows: const [
          Shadow(
            color: RSColors.titleShadow,
            offset: Offset(1, 2),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _viewGifImage() {
    final imagePath = letter.gifFilePath;
    if (imagePath != null) {
      return CachedNetworkImage(
        imageUrl: imagePath,
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
        const SizedBox(height: 108),
        Image.asset(res),
        const SizedBox(height: 8),
        const Text(RSStrings.letterNowLoading),
      ],
    );
  }

  Widget _errorIcon(String res) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 108),
        Image.asset(res),
        const SizedBox(height: 8),
        const Text(RSStrings.letterLoadingFailure, style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
