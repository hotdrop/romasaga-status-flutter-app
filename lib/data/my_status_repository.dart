import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/local/shared_prefs.dart';
import 'package:rsapp/data/local/dao/my_status_dao.dart';
import 'package:rsapp/data/remote/my_status_api.dart';
import 'package:rsapp/models/status.dart' show MyStatus;

final myStatusRepositoryProvider = Provider((ref) => _MyStatusRepository(ref));

class _MyStatusRepository {
  const _MyStatusRepository(this._ref);

  final Ref _ref;

  Future<List<MyStatus>> findAll() async {
    return await _ref.read(myStatusDaoProvider).findAll();
  }

  Future<MyStatus?> find(int id) async {
    return await _ref.read(myStatusDaoProvider).find(id);
  }

  Future<void> save(MyStatus status) async {
    return _ref.read(myStatusDaoProvider).save(status);
  }

  Future<void> backup() async {
    final myStatuses = await findAll();
    await _ref.read(myStatusApiProvider).save(myStatuses);

    final nowStr = DateTime.now().toString();
    await _ref.read(sharedPrefsProvider).saveBackupDate(nowStr);
  }

  Future<String?> getPreviousBackupDateStr() async {
    final dateStr = await _ref.read(sharedPrefsProvider).getBackupDate();
    if (dateStr == null || dateStr.length < 10) {
      return null;
    }
    return dateStr.substring(0, 10);
  }

  Future<void> restore() async {
    final myStatuses = await _ref.read(myStatusApiProvider).findAll();
    await _ref.read(myStatusDaoProvider).refresh(myStatuses);
  }
}
