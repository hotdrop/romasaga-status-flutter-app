import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/ui/letter/letter_view_model.dart';
import 'package:side_header_list_view/side_header_list_view.dart';

import 'letter_detail_page.dart';
import '../widget/custom_page_route.dart';
import '../../model/letter.dart';

import '../../common/rs_colors.dart';
import '../../common/rs_strings.dart';

class LetterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LetterViewModel.create()..load(),
      child: _loadingBody(),
    );
  }

  Widget _loadingBody() {
    return Consumer<LetterViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _loadingView();
        } else if (viewModel.isError) {
          return _errorView();
        } else {
          return _loadedView();
        }
      },
    );
  }

  Widget _loadingView() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(RSStrings.letterPageTitle),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _errorView() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(RSStrings.letterPageTitle),
      ),
      body: Center(
        child: Text(RSStrings.letterLoadingErrorMessage),
      ),
    );
  }

  Widget _loadedView() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(RSStrings.letterPageTitle),
      ),
      body: _widgetContents(),
    );
  }

  Widget _widgetContents() {
    return Consumer<LetterViewModel>(
      builder: (context, viewModel, child) {
        final items = viewModel.letters;
        if (items.isEmpty) {
          return Center(
            child: Text(RSStrings.letterNothingMessage),
          );
        } else {
          return SideHeaderListView(
            itemCount: items.length,
            itemExtend: 330.0,
            headerBuilder: (context, index) => _createHeader(items[index]),
            itemBuilder: (context, index) => _createCardLetter(context, items, index),
            hasSameHeader: (headerIndex, itemIndex) => items[headerIndex].year == items[itemIndex].year,
          );
        }
      },
    );
  }

  Widget _createHeader(Letter letter) {
    return Center(
      child: Text('${letter.year}${RSStrings.letterYearLabel}'),
    );
  }

  Widget _createCardLetter(BuildContext context, List<Letter> letters, int index) {
    final letter = letters[index];
    return Card(
      color: RSColors.thumbnailCardBackground,
      child: InkWell(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300,
              width: 200,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: letter.staticImagePath,
                      fit: BoxFit.fill,
                      // TODO ここなんかいい感じのplaceholderにしたい・・errorのイメージも同様
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset('res/charIcons/default.jpg', fit: BoxFit.fill),
                    ),
                  ),
                ],
              ),
            ),
            Text('${letter.month}${RSStrings.letterMonthLabel} ${letter.shortTitle}', style: TextStyle(color: letter.themeColor)),
          ],
        ),
        onTap: () {
          Navigator.push<void>(
            context,
            ScalePageRoute(page: LetterMainPage(selectedIndex: index, letters: letters)),
          );
        },
      ),
    );
  }
}
