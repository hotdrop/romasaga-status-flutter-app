import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/ui/information/letter/letter_page.dart';
import 'package:rsapp/ui/widget/app_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.infoPageTitle),
      ),
      body: Column(
        children: [
          const Expanded(
            child: _OfficialSiteWebView(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: AppIconButton(
              label: RSStrings.letterPageTitle,
              icon: Icons.mail_rounded,
              onTap: () async => await LetterPage.start(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialSiteWebView extends StatefulWidget {
  const _OfficialSiteWebView();
  @override
  State<StatefulWidget> createState() => _OfficialSiteWebViewState();
}

class _OfficialSiteWebViewState extends State<_OfficialSiteWebView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: RSStrings.infoOfficialUrl,
      javascriptMode: JavascriptMode.disabled,
      onWebViewCreated: (controller) {
        controller.clearCache();
      },
    );
  }
}
