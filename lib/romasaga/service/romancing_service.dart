import 'mixin_auth.dart';
import 'mixin_storage.dart';

class RomancingService with RomancingAuth, RomancingStorage {
  static final RomancingService _instance = RomancingService._();
  RomancingService._();

  factory RomancingService() {
    return _instance;
  }

  Future<void> load() async {
    await this.initAuth();
  }
}
