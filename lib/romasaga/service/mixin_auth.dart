import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

mixin RSAuthMixin {
  FirebaseUser _user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  Future<void> initAuth() async {
    if (_user != null) {
      return;
    }
    _user = await _firebaseAuth.currentUser();
  }

  bool get isLogIn => _user != null;

  String get uid => _user.uid;
  String get userName => _user.displayName;
  String get email => _user.email;

  Future<void> login() async {
    RSLogger.d("googleへサインインを開始します");
    final currentUser = _user ?? await _firebaseAuth.currentUser();
    if (currentUser != null) {
      RSLogger.d("すでにcurrentUserが設定されているのでサインイン処理終了");
      return currentUser;
    }

    RSLogger.d("サインイン処理を実行します。");
    final googleUser = await _google.signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final authResult = await _firebaseAuth.signInWithCredential(credential);
    _user = authResult.user;
    RSLogger.d('サインイン処理が完了しました。');
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _user = null;
  }
}
