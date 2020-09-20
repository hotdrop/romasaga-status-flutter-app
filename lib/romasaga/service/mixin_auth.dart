import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';

mixin RSAuthMixin {
  User _user;

  Future<void> initAuth() async {
    if (_user != null) {
      return;
    }
    await Firebase.initializeApp();
    _user = FirebaseAuth.instance.currentUser;
  }

  bool get isLogIn => _user != null;

  String get uid => _user.uid;
  String get userName => _user.displayName;
  String get email => _user.email;

  Future<void> login() async {
    RSLogger.d("googleへサインインを開始します");
    final currentUser = _user ?? FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      RSLogger.d("すでにcurrentUserが設定されているのでサインイン処理終了");
      return currentUser;
    }

    RSLogger.d("サインイン処理を実行します。");
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    _user = authResult.user;
    RSLogger.d('サインイン処理が完了しました。');
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
  }
}
