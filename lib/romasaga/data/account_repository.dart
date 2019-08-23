import '../service/rs_service.dart';

class AccountRepository {
  final RSService _romancingService;

  AccountRepository({RSService service}) : _romancingService = (service == null) ? RSService() : service;

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
