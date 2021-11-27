import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_images.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/information/letter/letter_row_item.dart';
import 'package:rsapp/ui/information/letter/letter_view_model.dart';
import 'package:rsapp/ui/widget/app_button.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/app_progress_dialog.dart';

class LetterPage extends ConsumerWidget {
  const LetterPage._();

  static Future<void> start(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LetterPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(letterViewModelProvider).uiState;
    return uiState.when(
      loading: (errMsg) => _onLoading(context, errMsg),
      success: () => _onSuccess(context, ref),
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) {
      if (errMsg != null) {
        AppDialog.onlyOk(message: errMsg).show(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.letterPageTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(letterViewModelProvider).isEmpty;
    if (isEmpty) {
      return _viewNothingData(context, ref);
    } else {
      return _viewLetters(context, ref);
    }
  }

  Widget _viewNothingData(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.letterPageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(RSImages.letterNotData),
            const Text(RSStrings.letterPageNotData),
            const SizedBox(height: 16),
            AppButton(
              label: RSStrings.letterPageLoadButton,
              onTap: () async => await _processLoadData(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processLoadData(BuildContext context, WidgetRef ref) async {
    await AppDialog.okAndCancel(
      message: RSStrings.letterPageLoadConfirmMessage,
      onOk: () async {
        const progressDialog = AppProgressDialog<void>();
        await progressDialog.show(
          context,
          execute: ref.read(letterViewModelProvider).refresh,
          onSuccess: (_) {/* 成功時は何もしない */},
          onError: (err) async => await AppDialog.onlyOk(message: err).show(context),
        );
      },
    ).show(context);
  }

  Widget _viewLetters(BuildContext context, WidgetRef ref) {
    final years = ref.read(letterViewModelProvider).findDistinctYears();
    return DefaultTabController(
      length: years.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(RSStrings.letterPageTitle),
          actions: <Widget>[
            IconButton(
              onPressed: () async => await _processLoadData(context, ref),
              icon: const Icon(Icons.refresh),
            ),
          ],
          bottom: TabBar(
            tabs: years.map((y) => Tab(text: '$y${RSStrings.letterYearLabel}')).toList(),
          ),
        ),
        body: TabBarView(
          children: years.map((y) => _createLetterTab(ref, y)).toList(),
        ),
      ),
    );
  }

  Widget _createLetterTab(WidgetRef ref, int year) {
    final letters = ref.read(letterViewModelProvider).findByYear(year);
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
