import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:rsapp/models/letter.dart';
import 'package:rsapp/res/rs_images.dart';
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
      body: Center(
        child: PageView.builder(
          controller: PageController(initialPage: _selectedIndex, keepPage: false),
          itemCount: _letters.length,
          itemBuilder: (context, index) => _LetterDetailPage(_letters[index]),
        ),
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
          _LetterTitle(letter),
          const SizedBox(height: 16),
          _VideoView(letter),
        ],
      ),
    );
  }
}

class _LetterTitle extends StatelessWidget {
  const _LetterTitle(this.letter);

  final Letter letter;

  @override
  Widget build(BuildContext context) {
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
  const _VideoView(this.letter);

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
      return const _ViewProcessError();
    }

    if (isInitialized()) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    } else {
      return const _ViewProcessLoading();
    }
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

class _ViewProcessLoading extends StatelessWidget {
  const _ViewProcessLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 108),
        Image.asset(RSImages.gifLoading),
        const SizedBox(height: 8),
        const Text(RSStrings.nowLoading),
      ],
    );
  }
}

class _ViewProcessError extends StatelessWidget {
  const _ViewProcessError();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 108),
        Image.asset(RSImages.gifLoading),
        const SizedBox(height: 8),
        const Text(
          RSStrings.letterLoadingFailure,
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
