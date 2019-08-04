import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../char_list_row_item.dart';
import '../search/search_list_view_model.dart';

import '../widget/romasaga_icon.dart';

import '../../model/character.dart';
import '../../model/weapon.dart';

import '../../common/strings.dart';

class SearchListTab extends StatefulWidget {
  final List<Character> _characters;

  SearchListTab(this._characters);

  @override
  _SearchListTabState createState() => _SearchListTabState(_characters);
}

class _SearchListTabState extends State<SearchListTab> with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  final List<Character> _characters;

  AnimationController _controller;
  final TextEditingController _searchQuery = TextEditingController();

  _SearchListTabState(this._characters);

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

  void _selectedFilter() {
    setState(() {
      _controller.fling(velocity: 2.0);
    });
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
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
            iconColor: theme.primaryIconTheme.color,
            textColor: theme.primaryTextTheme.title.color.withOpacity(0.6),
            selectedColor: theme.primaryTextTheme.title.color,
            child: _filterView(),
          ),
          PositionedTransition(
            rect: panelAnimation,
            child: _BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterView() {
    // フィルターしたい要素をここに詰めていく
    final filterViews = <Widget>[];
    filterViews.add(_filterViewWeaponType());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: filterViews,
      ),
    );
  }

  Widget _filterViewWeaponType() {
    return Consumer<SearchListViewModel>(builder: (_, viewModel, child) {
      return Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: WeaponType.types.map<Widget>((WeaponType type) {
          bool selected = viewModel.isSelectWeaponType(type);
          return RomasagaIcon.weaponWithRipple(
            type: type,
            selected: selected,
            onTap: () {
              _selectedFilter();
              viewModel.findByWeaponType(type);
            },
          );
        }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchListViewModel>(
      builder: (_) => SearchListViewModel(_characters),
      child: Scaffold(
        appBar: AppBar(
          title: _headerTitle(),
          actions: <Widget>[_headerIconSearchWord()],
        ),
        body: LayoutBuilder(builder: _buildStack),
      ),
    );
  }

  Widget _headerTitle() {
    return Consumer<SearchListViewModel>(builder: (_, viewModel, child) {
      if (viewModel.isKeywordSearch) {
        return TextField(
          controller: _searchQuery,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: Strings.SearchListQueryHint,
          ),
          onChanged: (String query) {
            viewModel.findByKeyword(query);
          },
        );
      } else {
        return Center(
          child: Text(Strings.SearchListTabTitle),
        );
      }
    });
  }

  Widget _headerIconSearchWord() {
    return Consumer<SearchListViewModel>(builder: (_, viewModel, child) {
      Widget searchIcon;
      if (viewModel.isKeywordSearch) {
        searchIcon = Icon(Icons.close, color: Colors.white);
      } else {
        searchIcon = Icon(Icons.search, color: Colors.white);
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
  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  const _BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
  }) : super(key: key);

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
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.subhead,
                // TODO このタイトルどうするか・・
                child: Text('Search'),
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
    return Consumer<SearchListViewModel>(
      builder: (_, viewModel, child) {
        return ListView.builder(itemBuilder: (BuildContext context, int index) {
          final characters = viewModel.charactersWithFilter;
          if (index < characters.length) {
            return CharListRowItem(
              character: characters[index],
            );
          }
          return null;
        });
      },
    );
  }
}
