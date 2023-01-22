import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_images.dart';
import 'package:rsapp/res/rs_strings.dart';

class ViewNowLoading extends StatelessWidget {
  const ViewNowLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(RSImages.loadingGifIcon),
          const SizedBox(height: 8),
          const Text(RSStrings.nowLoading),
        ],
      ),
    );
  }
}

class ViewLoadingError extends StatelessWidget {
  const ViewLoadingError({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(RSImages.loadingIconError),
            const Text(RSStrings.loadingError, style: TextStyle(color: Colors.red)),
            Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
