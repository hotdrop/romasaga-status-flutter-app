import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'char_list_row_item.dart';
import 'char_list_view_model.dart';

class CharListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CharListViewModel>(
        builder: (context, model, child) {
          final characters = model.findAll();
          return ListView.builder(itemBuilder: (BuildContext context, int index) {
            if (index < characters.length) {
              return CharListRowItem(
                character: characters[index],
              );
            }
            return null;
          });
        },
      ),
    );
  }
}
