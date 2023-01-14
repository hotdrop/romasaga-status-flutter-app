import 'dart:convert' as convert;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rsapp/res/env.dart';

mixin RSStorageMixin {
  Future<dynamic> getCharacters() async {
    return await _readJson(path: RSEnv.res.characterJsonFileName);
  }

  Future<dynamic> _readJson({required String path}) async {
    final url = await FirebaseStorage.instance.ref().child(path).getDownloadURL();
    final response = await http.get(Uri.parse(url));

    final bodyDecode = convert.utf8.decode(response.bodyBytes);
    return convert.jsonDecode(bodyDecode);
  }

  Future<String> getCharacterIconUrl(String fileName) async {
    return await _getDownloadUrl('icons/$fileName');
  }

  Future<String> _getDownloadUrl(String refPath) async {
    return FirebaseStorage.instance.ref().child(refPath).getDownloadURL();
  }
}
