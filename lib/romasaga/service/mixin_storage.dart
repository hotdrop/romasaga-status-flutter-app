import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

mixin RSStorageMixin {
  Future<String> readStagesJson() async {
    return await _readJson(path: 'stage.json');
  }

  Future<String> readCharactersJson() async {
    return await _readJson(path: 'characters.json');
  }

  Future<String> readLettersJson() async {
    return await _readJson(path: 'letters.json');
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
