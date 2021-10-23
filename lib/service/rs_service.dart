import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/models/rs_exception.dart';
import 'package:rsapp/service/mixin_auth.dart';
import 'package:rsapp/service/mixin_storage.dart';
import 'package:rsapp/service/mixin_firestore.dart';
import 'package:rsapp/models/status.dart' show MyStatus;

final rsServiceProvider = Provider((ref) => _RSService());

class _RSService with RSAuthMixin, RSStorageMixin, RSFirestoreMixin {
  _RSService();

  Future<void> init() async {
    await Firebase.initializeApp();
  }

  Future<void> saveMyStatuses(List<MyStatus> myStatuses) async {
    final currentUid = uid;
    if (currentUid == null) {
      throw const RSException(message: 'サインインしていないのでステータスを保存できません。');
    }
    await setMyStatuses(myStatuses, currentUid);
  }

  Future<List<MyStatus>> findMyStatues() async {
    final currentUid = uid;
    if (currentUid == null) {
      throw const RSException(message: 'サインインしていないのでステータスを取得できません。');
    }
    return await getMyStatues(currentUid);
  }
}
