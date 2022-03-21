import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/ui/base_view_model.dart';
import 'package:rsapp/ui/start/splash_view_model.dart';
import 'package:rsapp/ui/top_page.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(splashViewModelProvider).uiState;
    return Scaffold(
      body: uiState.when(
        loading: (String? errorMsg) => OnViewLoading(errorMessage: errorMsg),
        success: () => _onSuccess(context),
      ),
    );
  }

  Widget _onSuccess(BuildContext context) {
    Future.delayed(Duration.zero).then((_) async {
      await TopPage.start(context);
    });
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
