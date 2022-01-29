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

class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(searchViewModelProvider).uiState;
    return uiState.when(
      loading: (errMsg) => _onLoading(context, errMsg),
      success: () => _onSuccess(context, ref),
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

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: _viewHeaderTitle(ref),
        actions: [_viewHeaderIconSearchWord(ref)],
      ),
      body: _viewCharacters(ref),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.filter_list),
        onPressed: () {
          _viewBottomSheet(context, ref);
        },
      ),
    );
  }

  Widget _viewHeaderTitle(WidgetRef ref) {
    final isKeywordSearch = ref.watch(searchViewModelProvider).isKeywordSearch;
    if (isKeywordSearch) {
      return TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: RSStrings.searchListQueryHint,
        ),
        onSubmitted: (v) {
          ref.read(searchViewModelProvider).findByKeyword(v);
        },
      );
    } else {
      return const Text(RSStrings.searchPageTitle);
    }
  }

  Widget _viewHeaderIconSearchWord(WidgetRef ref) {
    final isKeywordSearch = ref.watch(searchViewModelProvider).isKeywordSearch;
    final searchIcon = isKeywordSearch ? const Icon(Icons.close) : const Icon(Icons.search);
    return IconButton(
      icon: searchIcon,
      onPressed: () {
        ref.read(searchViewModelProvider).changeSearchMode();
      },
    );
  }

  Widget _viewCharacters(WidgetRef ref) {
    final characters = ref.watch(searchViewModelProvider).charactersWithFilter;
    if (characters.isEmpty) {
      return const Center(
        child: Text(RSStrings.searchNoDataLabel),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: characters.length,
      itemBuilder: (_, index) {
        return RowCharacterItem(characters[index], refreshListener: () async {
          await ref.read(characterNotifierProvider.notifier).refresh();
        });
      },
    );
  }

  void _viewBottomSheet(BuildContext context, WidgetRef ref) {
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
          child: _viewFilter(ctx, ref),
        );
      },
    );
  }

  Widget _viewFilter(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _viewFilterKind(context, ref),
          Divider(color: Theme.of(context).primaryColor),
          _viewFilterWeaponType(context, ref),
          const SizedBox(height: 8),
          _viewFilterWeaponClearButton(context, ref),
          Divider(color: Theme.of(context).primaryColor),
          _viewFilterAttributes(context, ref),
          const SizedBox(height: 8),
          _viewFilterAttributeClearButton(context, ref),
          Divider(color: Theme.of(context).primaryColor),
          _viewFilterProduct(context, ref),
          const SizedBox(height: 8),
          _viewFilterProductionClearButton(context, ref),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _viewFilterKind(BuildContext context, WidgetRef ref) {
    return CategoryIcons(
      isFavSelected: ref.watch(searchViewModelProvider).isFilterFavorite,
      isHighLevelSelected: ref.watch(searchViewModelProvider).isFilterHighLevel,
      isAroundSelected: ref.watch(searchViewModelProvider).isFilterAround,
      onTap: (bool fav, bool high, bool around) {
        ref.read(searchViewModelProvider).filterCategory(favorite: fav, highLevel: high, around: around);
      },
    );
  }

  Widget _viewFilterWeaponType(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: WeaponType.values.map<Widget>((type) {
        return WeaponIcon.normal(
          type,
          selected: ref.read(searchViewModelProvider).isSelectWeaponType(type),
          onTap: () {
            ref.read(searchViewModelProvider).findByWeaponType(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  Widget _viewFilterWeaponClearButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearWeapon),
      onPressed: () {
        ref.read(searchViewModelProvider).clearFilterWeapon();
        Navigator.pop(context);
      },
    );
  }

  Widget _viewFilterAttributes(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: AttributeType.values.map<Widget>((type) {
        return AttributeIcon(
          type: type,
          selected: ref.read(searchViewModelProvider).isSelectAttributeType(type),
          onTap: () {
            ref.read(searchViewModelProvider).findByAttributeType(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  Widget _viewFilterAttributeClearButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearAttributes),
      onPressed: () {
        ref.read(searchViewModelProvider).clearFilterAttribute();
        Navigator.pop(context);
      },
    );
  }

  Widget _viewFilterProduct(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: ProductionType.values.map<Widget>((type) {
        return ProductionLogo(
          type: type,
          selected: ref.read(searchViewModelProvider).isSelectProductType(type),
          onTap: () {
            ref.read(searchViewModelProvider).findByProduction(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  Widget _viewFilterProductionClearButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearProduction),
      onPressed: () {
        ref.read(searchViewModelProvider).clearFilterProduction();
        Navigator.pop(context);
      },
    );
  }
}
