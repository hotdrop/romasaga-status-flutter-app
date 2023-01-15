import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rsapp/res/rs_colors.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/models/attribute.dart';
import 'package:rsapp/models/production.dart';
import 'package:rsapp/models/weapon.dart';
import 'package:rsapp/ui/widget/row_character.dart';
import 'package:rsapp/ui/search/search_providers.dart';
import 'package:rsapp/ui/widget/rs_icon.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _visibleFab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _ViewHeaderTitle(),
        actions: const [
          _ViewHeaderIconSearchWord(),
        ],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: ((notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() => _visibleFab = true);
          } else if (notification.direction == ScrollDirection.reverse) {
            setState(() => _visibleFab = false);
          }
          return true;
        }),
        child: const _ViewCharacters(),
      ),
      floatingActionButton: Visibility(
        visible: _visibleFab,
        child: FloatingActionButton(
          child: const Icon(Icons.filter_list),
          onPressed: () => showMaterialModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => const _BottomSheet(),
          ),
        ),
      ),
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
      onSubmitted: (v) => ref.read(searchControllerProvider.notifier).findByKeyword(v),
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
        ref.read(searchControllerProvider.notifier).changeSearchMode();
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
      itemBuilder: (_, index) => RowCharacterItem(characters[index]),
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
        ref.read(searchControllerProvider.notifier).filterCategory(favorite: fav, highLevel: high, around: around);
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
            ref.read(searchControllerProvider.notifier).findByWeaponType(type);
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
        ref.read(searchControllerProvider.notifier).clearFilterWeapon();
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
            ref.read(searchControllerProvider.notifier).findByAttributeType(type);
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
        ref.read(searchControllerProvider.notifier).clearFilterAttribute();
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
            ref.read(searchControllerProvider.notifier).findByProduction(type);
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
        ref.read(searchControllerProvider.notifier).clearFilterProduction();
        Navigator.pop(context);
      },
    );
  }
}
