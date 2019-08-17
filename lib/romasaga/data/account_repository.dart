import '../service/romancing_service.dart';

class AccountRepository {
  final RomancingService _romancingService;

  AccountRepository({RomancingService service}) : _romancingService = (service == null) ? RomancingService() : service;

  Future<void> load() async {
    await _romancingService.initAuth();
  }

  Future<void> login() async {
    await _romancingService.login();
  }

  Future<void> logout() async {
    await _romancingService.logout();
  }

  bool get isLogIn => _romancingService.isLogIn;

  String getUserName() {
    assert(isLogIn);
    return _romancingService.userName;
  }

  String getEmail() {
    assert(isLogIn);
    return _romancingService.email;
  }
}
