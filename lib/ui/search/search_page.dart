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
import 'package:rsapp/ui/widget/rs_icon.dart';
import 'package:rsapp/ui/widget/view_loading.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(searchViewModel).when(
          data: (_) {
            return Scaffold(
              appBar: AppBar(
                title: const _ViewHeaderTitle(),
                actions: const [
                  _ViewHeaderIconSearchWord(),
                ],
              ),
              body: const _ViewCharacters(),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.filter_list),
                onPressed: () => _onPressFab(context),
              ),
            );
          },
          error: (err, _) => OnViewLoading(errorMessage: '$err'),
          loading: () {
            Future<void>.delayed(Duration.zero).then((_) {
              ref.read(searchViewModel.notifier).init();
            });
            return const OnViewLoading();
          },
        );
  }

  void _onPressFab(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _BottomSheet(),
    );
  }
}

class _ViewHeaderTitle extends ConsumerWidget {
  const _ViewHeaderTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeywordSearch = ref.watch(searchIsKeyword);
    if (!isKeywordSearch) {
      return const Text(RSStrings.searchPageTitle);
    }

    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: RSStrings.searchListQueryHint,
      ),
      onSubmitted: (v) => ref.read(searchViewModel.notifier).findByKeyword(v),
    );
  }
}

class _ViewHeaderIconSearchWord extends ConsumerWidget {
  const _ViewHeaderIconSearchWord();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeywordSearch = ref.watch(searchIsKeyword);

    return IconButton(
      icon: isKeywordSearch ? const Icon(Icons.close) : const Icon(Icons.search),
      onPressed: () {
        ref.read(searchViewModel.notifier).changeSearchMode();
      },
    );
  }
}

class _ViewCharacters extends ConsumerWidget {
  const _ViewCharacters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(searchCharacterProvider);

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
          await ref.read(characterSNProvider.notifier).refresh();
        });
      },
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: RSColors.itemBackground,
        border: Border.all(width: 1, color: RSColors.itemBackground),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _ViewFilterKind(),
            Divider(color: Theme.of(context).primaryColor),
            const _ViewFilterWeaponClearButton(),
            const SizedBox(height: 8),
            const _ViewFilterWeaponType(),
            Divider(color: Theme.of(context).primaryColor),
            const _ViewFilterAttributeClearButton(),
            const SizedBox(height: 8),
            const _ViewFilterAttributes(),
            Divider(color: Theme.of(context).primaryColor),
            const _ViewFilterProductionClearButton(),
            const SizedBox(height: 8),
            const _ViewFilterProduct(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ViewFilterKind extends ConsumerWidget {
  const _ViewFilterKind();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CategoryIcons(
      isFavSelected: ref.read(searchFilterFavorite),
      isHighLevelSelected: ref.read(searchFilterUseHighLebel),
      isAroundSelected: ref.read(searchFilterUseAround),
      onTap: (bool fav, bool high, bool around) {
        ref.read(searchViewModel.notifier).filterCategory(favorite: fav, highLevel: high, around: around);
      },
    );
  }
}

class _ViewFilterWeaponType extends ConsumerWidget {
  const _ViewFilterWeaponType();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: WeaponType.values.map<Widget>((type) {
        return WeaponIcon.normal(
          type,
          selected: ref.watch(searchFilterWeaponType) == type,
          onTap: () {
            ref.read(searchViewModel.notifier).findByWeaponType(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}

class _ViewFilterWeaponClearButton extends ConsumerWidget {
  const _ViewFilterWeaponClearButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearWeapon),
      onPressed: () {
        ref.read(searchViewModel.notifier).clearFilterWeapon();
        Navigator.pop(context);
      },
    );
  }
}

class _ViewFilterAttributes extends ConsumerWidget {
  const _ViewFilterAttributes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: AttributeType.values.map<Widget>((type) {
        return AttributeIcon(
          type: type,
          selected: ref.watch(searchFilterAttributeType) == type,
          onTap: () {
            ref.read(searchViewModel.notifier).findByAttributeType(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}

class _ViewFilterAttributeClearButton extends ConsumerWidget {
  const _ViewFilterAttributeClearButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearAttributes),
      onPressed: () {
        ref.read(searchViewModel.notifier).clearFilterAttribute();
        Navigator.pop(context);
      },
    );
  }
}

class _ViewFilterProduct extends ConsumerWidget {
  const _ViewFilterProduct();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: ProductionType.values.map<Widget>((type) {
        return ProductionLogo(
          type: type,
          selected: ref.watch(searchFilterProductionType) == type,
          onTap: () {
            ref.read(searchViewModel.notifier).findByProduction(type);
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}

class _ViewFilterProductionClearButton extends ConsumerWidget {
  const _ViewFilterProductionClearButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      child: const Text(RSStrings.searchFilterClearProduction),
      onPressed: () {
        ref.read(searchViewModel.notifier).clearFilterProduction();
        Navigator.pop(context);
      },
    );
  }
}
