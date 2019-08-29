import 'mixin_auth.dart';
import 'mixin_storage.dart';
import 'mixin_firestore.dart';

import '../model/status.dart' show MyStatus;

class RSService with RSAuthMixin, RSStorageMixin, RSFirestoreMixin {
  static final RSService _instance = RSService._();
  RSService._();

  factory RSService() {
    return _instance;
  }

  Future<void> load() async {
    await this.initAuth();
  }

  Future<void> saveMyStatuses(List<MyStatus> myStatuses) async {
    await this.setMyStatuses(myStatuses, uid);
  }

  Future<List<MyStatus>> findMyStatues() async {
    return await this.getMyStatues(uid);
  }

  Future<String> getCharacterIconUrl(String fileName) async {
    if (isLogIn) {
      return await this.getImageUrl(fileName);
    } else {
      return null;
    }
  }
}
