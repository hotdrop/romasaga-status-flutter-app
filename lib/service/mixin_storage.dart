import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rsapp/res/env.dart';

mixin RSStorageMixin {
  Future<String> readStagesJson() async {
    return await _readJson(path: RSEnv.res.stageJsonFileName);
  }

  Future<String> readCharactersJson() async {
    return await _readJson(path: RSEnv.res.characterJsonFileName);
  }

  Future<String> readLettersJson() async {
    return await _readJson(path: RSEnv.res.lettersJsonFileName);
  }

  Future<String> _readJson({required String path}) async {
    final url = await FirebaseStorage.instance.ref().child(path).getDownloadURL();
    final response = await http.get(Uri.parse(url));
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getCharacterIconUrl(String fileName) async {
    return await _getDownloadUrl('icons/$fileName');
  }

  Future<String> getLetterImageUrl(String fileName) async {
    return await _getDownloadUrl('letters/$fileName');
  }

  Future<String> _getDownloadUrl(String refPath) async {
    return FirebaseStorage.instance.ref().child(refPath).getDownloadURL();
  }
}
