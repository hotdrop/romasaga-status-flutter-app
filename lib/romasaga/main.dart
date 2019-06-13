import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/char_list_view_model.dart';
import 'ui/app.dart';

void main() {
  return runApp(ChangeNotifierProvider<CharListViewModel>(
    builder: (context) => CharListViewModel()..load(),
    child: RomasagaApp(),
  ));
}
