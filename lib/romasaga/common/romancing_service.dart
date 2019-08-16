import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'saga_logger.dart';

class RomancingService {
  static final RomancingService _instance = RomancingService._();
  RomancingService._();

  factory RomancingService() {
    return _instance;
  }

  FirebaseUser _user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  Future<void> load() async {
    if (_user == null) {
      _user = await _firebaseAuth.currentUser();
    }
  }

  Future<void> login() async {
    SagaLogger.d("googleへサインインを開始します");
    final currentUser = _user ?? await _firebaseAuth.currentUser();
    if (currentUser != null) {
      SagaLogger.d("すでにcurrentUserが設定されているのでサインイン処理終了");
      return currentUser;
    }

    SagaLogger.d("サインイン処理を実行します。");
    final googleUser = await _google.signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final authResult = await _firebaseAuth.signInWithCredential(credential);
    _user = authResult.user;
    SagaLogger.d('サインイン処理が完了しました。');
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _user = null;
  }

  Future<String> readJson({String path}) async {
    final StorageReference ref = FirebaseStorage().ref().child(path);
    final String url = await ref.getDownloadURL();
    final http.Response response = await http.get(url);
    return utf8.decode(response.bodyBytes);
  }

  bool isLogIn() {
    return _user != null;
  }

  String get userName => _user?.displayName;
  String get email => _user?.email;
}
