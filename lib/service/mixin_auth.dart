import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rsapp/common/rs_logger.dart';
import 'package:rsapp/models/rs_exception.dart';

mixin RSAuthMixin {
  bool get isLogIn => FirebaseAuth.instance.currentUser != null;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  String? get userName => FirebaseAuth.instance.currentUser?.displayName;
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> signInWithGoogle() async {
    try {
      if (isLogIn) {
        RSLogger.d('すでにサインインしているので終了');
        return;
      }

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // サインインをキャンセルした場合はそのまま終了
        RSLogger.d('サインイン処理がキャンセルされたので終了');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      RSLogger.d('サインイン処理が完了しました。');
    } on PlatformException catch (e, s) {
      // TODO eを出力してthrowするのだるいからいっぺんにできたほうがいい。
      RSLogger.e('FirebaseAuth: サインイン処理でエラー', exception: e, stackTrace: s);
      throw RSException(message: 'サインイン処理でプラットフォームのエラーが発生しました。', exception: e, stackTrace: s);
    } on FirebaseAuthException catch (e, s) {
      RSLogger.e('FirebaseAuth: サインイン処理でエラー', exception: e, stackTrace: s);
      throw RSException(message: 'サインイン処理でFirebaseのエラーが発生しました。', exception: e, stackTrace: s);
    }
  }

  Future<void> signOut() async {
    GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
