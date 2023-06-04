import 'package:flutter/material.dart';
import 'package:rsapp/res/rs_strings.dart';
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
        children: const [
          Flexible(
            child: _OfficialSiteWebView(),
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
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..clearCache()
      ..loadRequest(Uri.parse(RSStrings.infoOfficialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
