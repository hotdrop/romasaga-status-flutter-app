import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsapp/romasaga/common/rs_strings.dart';
import 'package:rsapp/romasaga/model/attribute.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/page_state.dart';
import 'package:rsapp/romasaga/model/production.dart';
import 'package:rsapp/romasaga/model/weapon.dart';
import 'package:rsapp/romasaga/ui/characters/char_list_row_item.dart';
import 'package:rsapp/romasaga/ui/search/search_page_view_model.dart';
import 'package:rsapp/romasaga/ui/widget/rs_icon.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPageViewModel.create()..load(),
      builder: (context, child) {
        final pageState = context.select<SearchPageViewModel, PageState>((viewModel) => viewModel.pageState);
        if (pageState.nowLoading()) {
          return _loadingView();
        } else if (pageState.loadSuccess()) {
          return _loadSuccessView();
        } else {
          return _loadErrorView();
        }
      },
      child: _loadingView(),
    );
  }

  Widget _loadingView() {
    return Scaffold(
      appBar: AppBar(title: Text(RSStrings.searchPageTitle), centerTitle: true),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadErrorView() {
    return Scaffold(
      appBar: AppBar(title: Text(RSStrings.searchPageTitle), centerTitle: true),
      body: Center(
        child: Text(RSStrings.searchFilterLoadingErrorMessage),
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
    final viewModel = Provider.of<SearchPageViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: <Widget>[
          _filterViewSubTitle(context, RSStrings.searchFilterTitleOwn),
          _filterViewOwnState(context),
          _filterViewSubTitle(context, RSStrings.searchFilterTitleWeapon, onClearListener: () => viewModel.clearFilterWeapon()),
          _filterViewWeaponType(context),
          _filterViewSubTitle(context, RSStrings.searchFilterTitleAttributes, onClearListener: () => viewModel.clearFilterAttribute()),
          _filterViewAttributes(context),
          _filterViewSubTitle(context, RSStrings.searchFilterTitleProduction, onClearListener: () => viewModel.clearFilterProduction()),
          _filterViewProduct(context),
          SizedBox(height: 60.0),
        ],
      ),
    );
  }

  Widget _filterViewSubTitle(BuildContext context, String title, {Function() onClearListener}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 24.0, right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.subtitle2),
              if (onClearListener != null)
                FlatButton(
                  child: Text(RSStrings.searchFilterClear, style: TextStyle(color: Theme.of(context).accentColor)),
                  onPressed: () => onClearListener(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
          Divider(color: Theme.of(context).accentColor),
        ],
      ),
    );
  }

  Widget _filterViewOwnState(BuildContext context) {
    final viewModel = context.read<SearchPageViewModel>();
    bool selectedHaveChar = viewModel.isFilterHave();
    bool selectedFavorite = viewModel.isFilterFavorite();

    return Wrap(
      children: <Widget>[
        HaveCharacterIcon(
          selected: selectedHaveChar,
          onTap: () {
            viewModel.filterHaveChar(!selectedHaveChar);
          },
        ),
        SizedBox(width: 8.0),
        FavoriteIcon(
          selected: selectedFavorite,
          onTap: () {
            viewModel.filterFavorite(!selectedFavorite);
          },
        ),
      ],
    );
  }

  Widget _filterViewWeaponType(BuildContext context) {
    final viewModel = context.read<SearchPageViewModel>();

    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: WeaponType.values.map<Widget>((type) {
        bool selected = viewModel.isSelectWeaponType(type);
        return WeaponIcon.small(
          type,
          selected: selected,
          onTap: () {
            viewModel.findByWeaponType(type);
            _showBackDropPanel();
          },
        );
      }).toList(),
    );
  }

  Widget _filterViewAttributes(BuildContext context) {
    final viewModel = context.read<SearchPageViewModel>();

    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: AttributeType.values.map<Widget>((type) {
        bool selected = viewModel.isSelectAttributeType(type);
        return AttributeIcon.small(
          type,
          selected: selected,
          onTap: () {
            viewModel.findByAttributeType(type);
            _showBackDropPanel();
          },
        );
      }).toList(),
    );
  }

  Widget _filterViewProduct(BuildContext context) {
    final viewModel = context.read<SearchPageViewModel>();

    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: ProductionType.values.map<Widget>((type) {
        bool selected = viewModel.isSelectProductType(type);
        return ProductionLogo.normal(
          type,
          selected: selected,
          onTap: () {
            viewModel.findByProduction(type);
            _showBackDropPanel();
          },
        );
      }).toList(),
    );
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
        title: _headerTitle(context),
        centerTitle: true,
        actions: <Widget>[_headerIconSearchWord(context)],
      ),
      body: LayoutBuilder(builder: _buildStack),
    );
  }

  Widget _headerTitle(BuildContext context) {
    final viewModel = Provider.of<SearchPageViewModel>(context);

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
        onSubmitted: (v) {
          _showBackDropPanel();
        },
      );
    } else {
      return Text(RSStrings.searchPageTitle);
    }
  }

  Widget _headerIconSearchWord(BuildContext context) {
    final viewModel = Provider.of<SearchPageViewModel>(context);

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
                  Text(RSStrings.searchBackDropTitle, style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(width: 16.0),
                  visibleBackdropPanel ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
                ],
              ),
            ),
          ),
          const Divider(height: 1.0),
          Expanded(child: _searchResultList(context)),
        ],
      ),
    );
  }

  Widget _searchResultList(BuildContext context) {
    final characters = context.select<SearchPageViewModel, List<Character>>((vm) => vm.charactersWithFilter);

    return ListView.builder(itemBuilder: (_, index) {
      if (index < characters.length) {
        return CharListRowItem(characters[index]);
      }
      return null;
    });
  }
}
