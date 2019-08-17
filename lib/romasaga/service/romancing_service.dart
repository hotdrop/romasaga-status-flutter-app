import 'mixin_auth.dart';
import 'mixin_storage.dart';
import 'mixin_firestore.dart';

import '../model/status.dart' show MyStatus;

class RomancingService with RomancingAuth, RomancingStorage, RomancingFirestore {
  static final RomancingService _instance = RomancingService._();
  RomancingService._();

  factory RomancingService() {
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
}
