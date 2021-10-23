import 'package:flutter/foundation.dart';
import 'package:rsapp/models/page_state.dart';

class ChangeNotifierViewModel extends ChangeNotifier {
  PageState pageState = PageNowLoading();

  void nowLoading() {
    pageState = PageNowLoading();
    notifyListeners();
  }

  void loadSuccess() {
    pageState = PageLoaded();
    notifyListeners();
  }

  void loadError() {
    pageState = PageLoadError();
    notifyListeners();
  }
}
