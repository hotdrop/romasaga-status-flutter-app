import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/ui/letter/letter_row_item.dart';
import 'package:rsapp/romasaga/ui/letter/letter_view_model.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';

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
          return _loadSuccessView(context);
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
    return ListView.builder(itemBuilder: (context, index) {
      if (index < letters.length) {
        return LetterRowItem(index, letters);
      }
      return null;
    });
  }
}
