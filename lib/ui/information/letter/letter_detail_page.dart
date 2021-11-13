import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/res/rs_strings.dart';
import 'package:rsapp/res/rs_colors.dart';

class LetterDetailPage extends StatelessWidget {
  const LetterDetailPage._(this._selectedIndex, this._letters);

  static Future<void> start(BuildContext context, int index, List<Letter> letters) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => LetterDetailPage._(index, letters)),
    );
  }

  final int _selectedIndex;
  final List<Letter> _letters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(RSStrings.letterDetailPageTitle),
      ),
      body: _viewBody(context),
    );
  }

  Widget _viewBody(BuildContext context) {
    final controller = PageController(initialPage: _selectedIndex, keepPage: false);
    return Center(
      child: PageView.builder(
        controller: controller,
        itemCount: _letters.length,
        itemBuilder: (context, index) => _LetterDetailPage(_letters[index]),
      ),
    );
  }
}

class _LetterDetailPage extends StatelessWidget {
  const _LetterDetailPage(this.letter);

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16),
          _viewTitle(),
          const SizedBox(height: 16),
          _VideoView(letter),
        ],
      ),
    );
  }

  Widget _viewTitle() {
    return Text(
      '${letter.month}${RSStrings.letterMonthLabel} ${letter.title}',
      style: TextStyle(
        fontSize: 24.0,
        color: letter.themeColor,
        shadows: const [
          Shadow(
            color: RSColors.titleShadow,
            offset: Offset(1, 2),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView(this.letter, {Key? key}) : super(key: key);

  final Letter letter;

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    String? videoFilePath = widget.letter.videoFilePath;
    if (videoFilePath != null) {
      _controller = VideoPlayerController.network(videoFilePath);
      _controller!.initialize().then((_) {
        setState(() {});
        _controller!.setLooping(true);
        _controller!.play();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.letter.videoFilePath == null) {
      return _viewProcess(RSStrings.letterLoadingFailure, isError: true);
    }
    if (isInitialized()) {
      return AspectRatio(
        child: VideoPlayer(_controller!),
        aspectRatio: _controller!.value.aspectRatio,
      );
    } else {
      return _viewProcess(RSStrings.letterNowLoading);
    }
  }

  Widget _viewProcess(String label, {bool isError = false}) {
    final textWidget = (isError) ? Text(label, style: const TextStyle(color: Colors.red)) : Text(label);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 108),
        Image.asset(widget.letter.loadingIcon),
        const SizedBox(height: 8),
        textWidget,
      ],
    );
  }

  bool isInitialized() {
    return (_controller?.value != null && (_controller?.value.isInitialized ?? false));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
