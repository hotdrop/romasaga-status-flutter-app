import 'package:rsapp/romasaga/service/mixin_auth.dart';
import 'package:rsapp/romasaga/service/mixin_storage.dart';
import 'package:rsapp/romasaga/service/mixin_firestore.dart';
import 'package:rsapp/models/status.dart' show MyStatus;

class RSService with RSAuthMixin, RSStorageMixin, RSFirestoreMixin {
  RSService._();
  factory RSService.getInstance() {
    return _instance;
  }

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
