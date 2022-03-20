import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';

part 'base_view_model.freezed.dart';

class BaseViewModel extends ChangeNotifier {
  UIState _uiState = const OnLoading();
  UIState get uiState => _uiState;

  void nowLoading() {
    _uiState = const OnLoading();
    notifyListeners();
  }

  void onSuccess() {
    _uiState = const OnSuccess();
    notifyListeners();
  }

  void onError(String message) {
    _uiState = OnLoading(errorMsg: message);
    notifyListeners();
  }
}

@freezed
class UIState with _$UIState {
  const factory UIState.loading({String? errorMsg}) = OnLoading;
  const factory UIState.success() = OnSuccess;
}

class OnViewLoading extends StatelessWidget {
  const OnViewLoading({Key? key, this.title, required this.errorMessage}) : super(key: key);

  final String? title;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((_) async {
      if (errorMessage != null) {
        await AppDialog.onlyOk(message: errorMessage!).show(context);
      }
    });

    if (title != null) {
      return Scaffold(
        appBar: AppBar(title: Text(title!)),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
