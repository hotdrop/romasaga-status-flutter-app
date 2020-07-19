import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/model/page_state.dart';
import 'package:rsapp/romasaga/model/status.dart';
import 'package:rsapp/romasaga/ui/dashboard/dashboard_view_model.dart';
import 'package:rsapp/romasaga/ui/widget/custom_rs_widgets.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel.create()..load(),
      builder: (context, child) {
        final pageState = context.select<DashboardViewModel, PageState>((viewModel) => viewModel.pageState);
        if (pageState.nowLoading()) {
          return _loadingView();
        } else if (pageState.loadSuccess()) {
          return _loadedView(context);
        } else {
          return _loadErrorView();
        }
      },
      child: _loadingView(),
    );
  }

  Widget _loadingView() {
    return Scaffold(
      appBar: AppBar(title: Text(RSStrings.dashboardPageTitle), centerTitle: true),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadErrorView() {
    return Scaffold(
      appBar: AppBar(title: Text(RSStrings.dashboardPageTitle), centerTitle: true),
      body: Center(
        child: Text(RSStrings.dashboardPageLoadingErrorMessage),
      ),
    );
  }

  Widget _loadedView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(RSStrings.dashboardPageTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: _contentsCharacterNum(context),
      ),
    );
  }

  ///
  /// 上部に表示するお気に入りや保持キャラ数のWidget
  ///
  Widget _contentsCharacterNum(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _columnCharacterNum(context, _makeFavoriteIconTitle(context), RSStrings.dashboardPageFavoriteCharLabel, viewModel.favoriteNum),
          VerticalColorBorder(color: Theme.of(context).dividerColor),
          _columnCharacterNum(context, _makeHaveIconTitle(context), RSStrings.dashboardPageHaveCharLabel, viewModel.haveNum),
          VerticalColorBorder(color: Theme.of(context).dividerColor),
          _columnCharacterNum(context, _makeAllIconTitle(context), RSStrings.dashboardPageAllCharLabel, viewModel.allCharNum),
        ],
      ),
    );
  }

  Widget _columnCharacterNum(BuildContext context, Widget titleView, String detail, int num) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        titleView,
        SizedBox(height: 8.0),
        Text(num.toString(), style: Theme.of(context).textTheme.headline5),
        SizedBox(height: 4.0),
        Text(detail, style: TextStyle(color: Colors.grey, fontSize: 12.0)),
      ],
    );
  }

  Widget _makeFavoriteIconTitle(BuildContext context) => Icon(Icons.favorite, color: Theme.of(context).accentColor);

  Widget _makeHaveIconTitle(BuildContext context) => Icon(Icons.people, color: Theme.of(context).accentColor);

  Widget _makeAllIconTitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.people, color: Theme.of(context).accentColor),
        Text(' + ', style: TextStyle(color: Theme.of(context).accentColor)),
        Icon(Icons.people_outline, color: Theme.of(context).accentColor),
      ],
    );
  }

  ///
  /// 各キャラのステータスランキング
  ///
  Widget _contentsStatusRanking(BuildContext context) {
    // TODO ステータス毎のランキング作る。HPはソートで見れるのでいらない
  }

  Widget _rankingView(StatusType type) {
    // TODO 1位〜5位までのキャラを取得する
    // TODO 位のアイコン、数値、キャラアイコン、名前を表示
  }
}
