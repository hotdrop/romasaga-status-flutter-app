import 'package:flutter/foundation.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/model/page_state.dart';

class ChangeNotifierViewModel extends ChangeNotifier {
  PageState pageState = PageNowLoading();

  Future<void> run({
    @required String label,
    @required Future<void> block(),
    void onError(Exception e),
  }) async {
    nowLoading();

    try {
      await block();
    } on Exception catch (e) {
      RSLogger.d('$label の実行でエラーが発生しました。message=${e.toString()}');
      onError?.call(e);
      loadError();
    }

    loadSuccess();
  }

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
