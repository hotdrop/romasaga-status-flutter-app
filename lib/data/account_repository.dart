import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/service/rs_service.dart';

final accountRepositoryProvider = Provider((ref) => _AccountRepository(ref.read));

class _AccountRepository {
  const _AccountRepository(this._read);

  final Reader _read;

  Future<void> signIn() async {
    await _read(rsServiceProvider).signInWithGoogle();
  }

  Future<void> signOut() async {
    await _read(rsServiceProvider).signOut();
  }

  bool get isLogIn => _read(rsServiceProvider).isLogIn;

  String? getUserName() {
    return _read(rsServiceProvider).userName;
  }

  String? getEmail() {
    return _read(rsServiceProvider).email;
  }
}
