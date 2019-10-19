import 'mixin_auth.dart';
import 'mixin_storage.dart';
import 'mixin_firestore.dart';

import '../model/status.dart' show MyStatus;

class RSService with RSAuthMixin, RSStorageMixin, RSFirestoreMixin {
  factory RSService() {
    return _instance;
  }

  RSService._();

  static final RSService _instance = RSService._();

  Future<void> load() async {
    await this.initAuth();
  }

  Future<void> saveMyStatuses(List<MyStatus> myStatuses) async {
    await this.setMyStatuses(myStatuses, uid);
  }

  Future<List<MyStatus>> findMyStatues() async {
    return await this.getMyStatues(uid);
  }
}
