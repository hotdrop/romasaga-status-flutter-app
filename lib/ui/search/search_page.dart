import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rsapp/models/character.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/production.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/ui/widget/row_character.dart';
import 'package:rsapp/ui/search/search_view_model.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final uiState = watch(searchViewModelProvider).uiState;
        return uiState.when(
          loading: (errMsg) => _onLoading(context, errMsg),
          success: () => _onSuccess(context),
        );
      },
    );
  }

  Widget _onLoading(BuildContext context, String? errMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errMsg != null) {
        await AppDialog.onlyOk(message: errMsg).show(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.searchPageTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _onSuccess(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _headerTitle(context),
        actions: [_headerIconSearchWord(context)],
      ),
      body: _viewCharacters(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.filter_list),
        onPressed: () {
          _showBottomSheet(context);
        },
      ),
    );
  }

  Widget _headerTitle(BuildContext context) {
    final isKeywordSearch = context.read(searchViewModelProvider).isKeywordSearch;
    if (isKeywordSearch) {
      return TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: RSStrings.searchListQueryHint,
        ),
        onSubmitted: (v) {
          context.read(searchViewModelProvider).findByKeyword(v);
        },
      );
    } else {
      return const Text(RSStrings.searchPageTitle);
    }
  }

  Widget _headerIconSearchWord(BuildContext context) {
    final isKeywordSearch = context.read(searchViewModelProvider).isKeywordSearch;
    final searchIcon = isKeywordSearch ? const Icon(Icons.close) : const Icon(Icons.search);
    return IconButton(
      icon: searchIcon,
      onPressed: () {
        context.read(searchViewModelProvider).changeSearchMode();
      },
    );
  }

  Widget _viewCharacters(BuildContext context) {
    final characters = context.read(searchViewModelProvider).charactersWithFilter;
    if (characters.isEmpty) {
      return const Center(
        child: Text(RSStrings.searchNoDataLabel),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return RowCharacterItem(characters[index], refreshListener: () async {
          await context.read(characterNotifierProvider.notifier).refresh();
        });
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(ctx).size.height * 0.8,
          decoration: BoxDecoration(
            color: RSColors.itemBackground,
            border: Border.all(width: 1, color: RSColors.itemBackground),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: _viewFilterContents(ctx),
        );
      },
    );
  }

  Widget _viewFilterContents(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _viewFilterFavorite(context),
          Divider(color: Theme.of(context).primaryColor),
          _filterViewWeaponType(context),
          const SizedBox(height: 8),
          _viewFilterWeaponClearButton(context),
          Divider(color: Theme.of(context).primaryColor),
          _filterViewAttributes(context),
          const SizedBox(height: 8),
          _viewFilterAttributeClearButton(context),
          Divider(color: Theme.of(context).primaryColor),
          _filterViewProduct(context),
          const SizedBox(height: 8),
          _viewFilterProductionClearButton(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _viewFilterFavorite(BuildContext context) {
    bool selectedFavorite = context.read(searchViewModelProvider).isFilterFavorite();
    return FavoriteIcon(
      selected: selectedFavorite,
      onTap: () {
        context.read(searchViewModelProvider).filterFavorite(!selectedFavorite);
        Navigator.pop(context);
      },
    );
  }

  Widget _filterViewWeaponType(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: WeaponType.values.map<Widget>((type) {
        return WeaponIcon.normal(
          type,
          selected: context.read(searchViewModelProvider).isSelectWeaponType(type),
          onTap: () {
            context.read(searchViewModelProvider).findByWeaponType(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  Widget _viewFilterWeaponClearButton(BuildContext context) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearWeapon),
      onPressed: () {
        context.read(searchViewModelProvider).clearFilterWeapon();
        Navigator.pop(context);
      },
    );
  }

  Widget _filterViewAttributes(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: AttributeType.values.map<Widget>((type) {
        return AttributeIcon(
          type: type,
          selected: context.read(searchViewModelProvider).isSelectAttributeType(type),
          onTap: () {
            context.read(searchViewModelProvider).findByAttributeType(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  Widget _viewFilterAttributeClearButton(BuildContext context) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearAttributes),
      onPressed: () {
        context.read(searchViewModelProvider).clearFilterAttribute();
        Navigator.pop(context);
      },
    );
  }

  Widget _filterViewProduct(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: ProductionType.values.map<Widget>((type) {
        return ProductionLogo(
          type: type,
          selected: context.read(searchViewModelProvider).isSelectProductType(type),
          onTap: () {
            context.read(searchViewModelProvider).findByProduction(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  Widget _viewFilterProductionClearButton(BuildContext context) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearProduction),
      onPressed: () {
        context.read(searchViewModelProvider).clearFilterProduction();
        Navigator.pop(context);
      },
    );
  }
}
