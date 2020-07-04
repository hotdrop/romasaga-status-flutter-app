import 'package:flutter/foundation.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

class ChangeNotifierViewModel extends ChangeNotifier {
  _PageState _pageState = _PageState.loading;
  bool get isLoading => _pageState == _PageState.loading;
  bool get isLoaded => _pageState == _PageState.loaded;
  bool get isError => _pageState == _PageState.error;

  Future<void> run({
    @required String label,
    @required Future<void> block(),
    void onError(Exception e),
  }) async {
    _nowLoading();

    try {
      await block();
    } on Exception catch (e) {
      RSLogger.d('$label の実行でエラーが発生しました。message=${e.toString()}');
      onError?.call(e);
      _loadError();
      notifyListeners();
    }

    _loadSuccess();
    notifyListeners();
  }

  void _nowLoading() {
    _pageState = _PageState.loading;
  }

  void _loadSuccess() {
    _pageState = _PageState.loaded;
  }

  void _loadError() {
    _pageState = _PageState.error;
  }
}

enum _PageState { loading, loaded, error }
