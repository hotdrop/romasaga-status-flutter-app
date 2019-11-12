import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../characters/char_list_row_item.dart';
import '../search/search_page_view_model.dart';
import '../widget/rs_icon.dart';
import '../../model/weapon.dart';
import '../../common/rs_strings.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => SearchPageViewModel.create()..load(),
      child: _loadingBody(),
    );
  }

  Widget _loadingBody() {
    return Consumer<SearchPageViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _loadingView();
        } else if (viewModel.isSuccess) {
          return _loadSuccessView();
        } else {
          return _loadErrorView();
        }
      },
    );
  }

  Widget _loadingView() {
    return Scaffold(
      appBar: AppBar(title: Text(RSStrings.searchListTitle), centerTitle: true),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadErrorView() {
    return Scaffold(
      appBar: AppBar(title: Text(RSStrings.searchListTitle), centerTitle: true),
      body: Center(
        child: Text(RSStrings.searchFilerLoadingErrorMessage),
      ),
    );
  }

  Widget _loadSuccessView() {
    return _SearchPage();
  }
}

class _SearchPage extends StatefulWidget {
  _SearchPage();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> with SingleTickerProviderStateMixin {
  _SearchPageState();

  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  AnimationController _controller;
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    final renderBox = _backdropKey.currentContext.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed) {
      return;
    }
    _controller.value -= details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed) {
      return;
    }

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0) {
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    } else {
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
    }
  }

  ///
  /// backdropの実装
  ///
  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    final Animation<RelativeRect> panelAnimation = _controller.drive(
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(0.0, panelTop - MediaQuery.of(context).padding.bottom, 0.0, panelTop - panelSize.height),
        end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
      ),
    );

    final ThemeData theme = Theme.of(context);

    return Container(
      key: _backdropKey,
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          ListTileTheme(
            child: _filterView(context),
          ),
          PositionedTransition(
            rect: panelAnimation,
            child: _BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              visibleBackdropPanel: _backdropPanelVisible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterView(BuildContext context) {
    // フィルターしたい要素をここに詰めていく
    final filterViews = <Widget>[];
    filterViews.add(_filterViewSubTitle(context, RSStrings.searchFilerTitleOwn));
    filterViews.add(_filterViewOwnState());
    filterViews.add(_filterViewSubTitle(context, RSStrings.searchFilerTitleWeapon));
    filterViews.add(_filterViewWeaponType());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: filterViews,
      ),
    );
  }

  Widget _filterViewSubTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.0, top: 32.0, right: 4.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.subtitle),
          Divider(color: Theme.of(context).accentColor),
        ],
      ),
    );
  }

  Widget _filterViewOwnState() {
    return Consumer<SearchPageViewModel>(builder: (context, viewModel, child) {
      bool selectedHaveChar = viewModel.isFilterHave();
      bool selectedFavorite = viewModel.isFilterFavorite();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RSIcon.haveCharacterWithRipple(
            context: context,
            selected: selectedHaveChar,
            onTap: () {
              viewModel.filterHaveChar(!selectedHaveChar);
            },
          ),
          const SizedBox(width: 16.0),
          RSIcon.favoriteWithRipple(
            context: context,
            selected: selectedFavorite,
            onTap: () {
              viewModel.filterFavorite(!selectedFavorite);
            },
          )
        ],
      );
    });
  }

  Widget _filterViewWeaponType() {
    return Consumer<SearchPageViewModel>(builder: (context, viewModel, child) {
      return Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: WeaponType.types.map<Widget>((type) {
          bool selected = viewModel.isSelectWeaponType(type);
          return RSIcon.weaponWithRipple(
            context,
            type: type,
            selected: selected,
            onTap: () {
              viewModel.findByWeaponType(type);
              _showBackDropPanel();
            },
          );
        }).toList(),
      );
    });
  }

  void _showBackDropPanel() {
    setState(() {
      _controller.fling(velocity: 2.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _headerTitle(),
        centerTitle: true,
        actions: <Widget>[_headerIconSearchWord()],
      ),
      body: LayoutBuilder(builder: _buildStack),
    );
  }

  Widget _headerTitle() {
    return Consumer<SearchPageViewModel>(builder: (_, viewModel, child) {
      if (viewModel.isKeywordSearch) {
        return TextField(
          controller: _searchQuery,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: RSStrings.searchListQueryHint,
          ),
          onChanged: (query) {
            viewModel.findByKeyword(query);
          },
        );
      } else {
        return Text(RSStrings.searchListTitle);
      }
    });
  }

  Widget _headerIconSearchWord() {
    return Consumer<SearchPageViewModel>(builder: (_, viewModel, child) {
      Widget searchIcon;
      if (viewModel.isKeywordSearch) {
        searchIcon = Icon(Icons.close);
      } else {
        searchIcon = Icon(Icons.search);
      }
      return IconButton(
        icon: searchIcon,
        onPressed: () {
          if (viewModel.isKeywordSearch) {
            _searchQuery.clear();
          }
          viewModel.tapSearchIcon();
        },
      );
    });
  }
}

class _BackdropPanel extends StatelessWidget {
  const _BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.visibleBackdropPanel,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final bool visibleBackdropPanel;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(width: 16.0),
                  const SizedBox(width: 16.0),
                  Text(RSStrings.searchBackDropTitle, style: Theme.of(context).textTheme.subhead),
                  const SizedBox(width: 16.0),
                  visibleBackdropPanel ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
                ],
              ),
            ),
          ),
          const Divider(height: 1.0),
          Expanded(child: _searchResultList()),
        ],
      ),
    );
  }

  Widget _searchResultList() {
    return Consumer<SearchPageViewModel>(
      builder: (_, viewModel, child) {
        return ListView.builder(itemBuilder: (_, index) {
          final characters = viewModel.charactersWithFilter;
          if (index < characters.length) {
            return CharListRowItem(characters[index]);
          }
          return null;
        });
      },
    );
  }
}
