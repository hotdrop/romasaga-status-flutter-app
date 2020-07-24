import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/model/page_state.dart';
import 'package:rsapp/romasaga/model/status.dart';
import 'package:rsapp/romasaga/ui/dashboard/dashboard_view_model.dart';
import 'package:rsapp/romasaga/ui/widget/custom_rs_widgets.dart';
import 'package:rsapp/romasaga/ui/widget/status_ranking_container.dart';

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
      body: ListView(
        padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 16.0),
        children: <Widget>[
          _contentsCharacterNum(context),
          const SizedBox(height: 16.0),
          _contentsTopRanker(context),
          const SizedBox(height: 16.0),
          _contentsStatusRanking(context),
        ],
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
        const SizedBox(height: 8.0),
        Text(num.toString(), style: Theme.of(context).textTheme.headline5),
        const SizedBox(height: 4.0),
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

  /// TODO ランキングが一番多いキャラを表示したい
  Widget _contentsTopRanker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0, left: 48.0, right: 48.0, bottom: 16.0),
      child: Text('ここにランキングトップキャラとチャートを表示したいが・・'),
    );
  }

  ///
  /// 各キャラのステータスランキング
  /// HPはキャラ一覧のソートで確認できるので表示しない
  ///
  Widget _contentsStatusRanking(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);

    return SizedBox(
      height: 280.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          StatusRankingContainer(StatusType.str, viewModel.strTop5),
          StatusRankingContainer(StatusType.vit, viewModel.vitTop5),
          StatusRankingContainer(StatusType.dex, viewModel.dexTop5),
          StatusRankingContainer(StatusType.agi, viewModel.agiTop5),
          StatusRankingContainer(StatusType.intelligence, viewModel.intTop5),
          StatusRankingContainer(StatusType.spirit, viewModel.spiritTop5),
          StatusRankingContainer(StatusType.love, viewModel.loveTop5),
          StatusRankingContainer(StatusType.attr, viewModel.attrTop5),
        ],
      ),
    );
  }
}
