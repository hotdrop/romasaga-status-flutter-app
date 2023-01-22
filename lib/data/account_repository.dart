import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/service/rs_service.dart';

final accountRepositoryProvider = Provider((ref) => _AccountRepository(ref));

class _AccountRepository {
  const _AccountRepository(this._ref);

  final Ref _ref;

  Future<void> signIn() async {
    await _ref.read(rsServiceProvider).signInWithGoogle();
  }

  Future<void> signOut() async {
    await _ref.read(rsServiceProvider).signOut();
  }

  bool get isLogIn => _ref.read(rsServiceProvider).isLogIn;

  String? getUserName() {
    return _ref.read(rsServiceProvider).userName;
  }

  String? getEmail() {
    return _ref.read(rsServiceProvider).email;
  }
}
