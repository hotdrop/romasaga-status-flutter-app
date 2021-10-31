import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/res/rs_images.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/start/splash_view_model.dart';
import 'package:rsapp/ui/widget/rs_dialog.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.appTitle),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(splashViewModelProvider).uiState;
          return uiState.when(
            loading: (String? errorMsg) => _onLoading(context, errorMsg),
            success: () => _onSuccess(context),
          );
        },
      ),
    );
  }

  Widget _onLoading(BuildContext context, String? errorMsg) {
    Future.delayed(Duration.zero).then((_) {
      if (errorMsg != null) {
        AppDialogWithClosePage(errorMsg).show(context);
      }
    });
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(RSImages.splashImage),
          const SizedBox(height: 32),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _onSuccess(BuildContext context) {
    // トップページに遷移する
    throw UnimplementedError();
  }
}
