import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/model/page_state.dart';
import 'package:rsapp/romasaga/ui/letter/letter_row_item.dart';
import 'package:rsapp/romasaga/ui/letter/letter_view_model.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';

class LetterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LetterViewModel.create()..load(),
      builder: (context, child) {
        final pageState = context.select<LetterViewModel, PageState>((viewModel) => viewModel.pageState);
        if (pageState.nowLoading()) {
          return _loadingView();
        } else if (pageState.loadSuccess()) {
          return _loadSuccessView(context);
        } else {
          return _errorView();
        }
      },
      child: _loadingView(),
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

  Widget _loadSuccessView(BuildContext context) {
    final viewModel = Provider.of<LetterViewModel>(context);
    final years = viewModel.getDistinctYears();

    return DefaultTabController(
      length: years.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(RSStrings.letterPageTitle),
          bottom: TabBar(
            tabs: years.map((y) => Tab(text: '$y${RSStrings.letterYearLabel}')).toList(),
          ),
        ),
        body: TabBarView(
          children: years.map((y) => _createLetterTab(context, y)).toList(),
        ),
      ),
    );
  }

  Widget _createLetterTab(BuildContext context, int year) {
    final viewModel = Provider.of<LetterViewModel>(context);

    final letters = viewModel.letterByYear(year);
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2 / 3,
      children: List.generate(
        letters.length,
        (index) => LetterRowItem(index, letters),
      ),
    );
  }
}
