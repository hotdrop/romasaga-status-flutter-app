import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/app_settings.dart';
import 'package:rsapp/ui/base_view_model.dart';

final splashViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _SplashViewModel(ref.read));

class _SplashViewModel extends BaseViewModel {
  _SplashViewModel(this._read) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    // ここでアプリに必要な初期処理を行う
    await _read(appSettingsProvider.notifier).init();
    onSuccess();
  }
}
