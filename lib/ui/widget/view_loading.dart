import 'package:flutter/material.dart';
import 'package:rsapp/ui/widget/app_dialog.dart';

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
