import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_images.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';

class ViewLoading extends StatelessWidget {
  const ViewLoading({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((_) async {
      if (errorMessage != null) {
        await AppDialog.onlyOk(message: errorMessage!).show(context);
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 108),
          Image.asset(RSImages.gifLoading),
          const SizedBox(height: 8),
          const Text(RSStrings.nowLoading),
        ],
      ),
    );
  }
}

@Deprecated('このクラスは使わない。ViewLoadingを使う')
class OnViewLoading extends StatelessWidget {
  const OnViewLoading({super.key, this.title, this.errorMessage});

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 108),
              Image.asset(RSImages.gifLoading),
              const SizedBox(height: 8),
              const Text(RSStrings.nowLoading),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
