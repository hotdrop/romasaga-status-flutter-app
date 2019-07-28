import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../char_list_row_item.dart';
import '../search/search_list_view_model.dart';

import '../../model/character.dart';
import '../../common/strings.dart';

class SearchListTab extends StatelessWidget {
  final List<Character> _characters;
  final TextEditingController _searchQuery = TextEditingController();

  SearchListTab(this._characters);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchListViewModel>(
      builder: (_) => SearchListViewModel(_characters),
      child: Scaffold(
        appBar: AppBar(
          title: _appBarTitleArea(),
          actions: <Widget>[
            _searchIcon(),
          ],
        ),
        body: _searchResultList(),
      ),
    );
  }

  Widget _appBarTitleArea() {
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

  Widget _searchIcon() {
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
