import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widget/rs_icon.dart';
import '../../service/rs_service.dart';

import '../../common/rs_logger.dart';

class CharacterIconLoader {
  final RSService _rsService;
  CharacterIconLoader({RSService rsSrv}) : _rsService = (rsSrv == null) ? RSService() : rsSrv;

  Future<void> init() async {
    await _rsService.load();
  }

  Widget load(String fileName) {
    return _loadImage(fileName, RSIcon.normalSize);
  }

  Widget loadLargeSize(String fileName) {
    return _loadImage(fileName, RSIcon.largeSize);
  }

  Widget _loadImage(String fileName, double size) {
    return FutureBuilder(
      future: _futureLoadImage(fileName, size),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else {
          return _defaultIcon(size);
        }
      },
    );
  }

  Future<Widget> _futureLoadImage(String fileName, double size) async {
    final path = await _rsService.getCharacterIconUrl(fileName);
    return path == null
        ? _defaultIcon(size)
        : CachedNetworkImage(
            imageUrl: path,
            width: size,
            height: size,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) {
              RSLogger.e('画像ロードでエラー', error);
              return Icon(Icons.error);
            },
          );
  }

  Widget _defaultIcon(double size) {
    return Image.asset(
      'res/charIcons/default.jpg',
      width: size,
      height: size,
    );
  }
}
