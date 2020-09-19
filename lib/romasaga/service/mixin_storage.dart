import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rsapp/romasaga/common/rs_env.dart';

mixin RSStorageMixin {
  Future<String> readStagesJson() async {
    return await _readJson(path: RSEnv.instance.stageJsonFileName);
  }

  Future<String> readCharactersJson() async {
    return await _readJson(path: RSEnv.instance.characterJsonFileName);
  }

  Future<String> readLettersJson() async {
    return await _readJson(path: RSEnv.instance.lettersJsonFileName);
  }

  Future<String> _readJson({String path}) async {
    final StorageReference ref = FirebaseStorage().ref().child(path);
    final String url = await ref.getDownloadURL() as String;
    final http.Response response = await http.get(url);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getCharacterIconUrl(String fileName) async {
    return await _getDownloadUrl('icons/$fileName');
  }

  Future<String> getLetterImageUrl(String fileName) async {
    return await _getDownloadUrl('letters/$fileName');
  }

  Future<String> _getDownloadUrl(String refPath) async {
    final StorageReference ref = FirebaseStorage().ref().child(refPath);
    return await ref.getDownloadURL() as String;
  }
}
