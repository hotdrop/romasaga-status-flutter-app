import 'local/my_status_source.dart';
import 'remote/my_status_api.dart';

import '../model/status.dart' show MyStatus;

import '../common/saga_logger.dart';

class MyStatusRepository {
  final MyStatusSource _localDataSource;
  final MyStatusApi _remoteDataSource;

  MyStatusRepository({MyStatusSource local, MyStatusApi remote})
      : _localDataSource = (local == null) ? MyStatusSource() : local,
        _remoteDataSource = (remote == null) ? MyStatusApi() : remote;

  Future<List<MyStatus>> findAll() async {
    return await _localDataSource.findAll();
  }

  Future<MyStatus> find(int id) async {
    return await _localDataSource.find(id) ?? MyStatus.empty(id);
  }

  Future<void> save(MyStatus status) async {
    return _localDataSource.save(status);
  }

  String getPreviousBackupDate() {
    // TODO sharedから取得
    return '2019-08-10';
  }

  Future<void> backup() async {
    final myStatuses = await findAll();
    await _remoteDataSource.save(myStatuses);

    // TODO 成功したら日付を保存
  }

  Future<void> restore() async {
    // TODO firestoreからデータ取得してsaveを実行
  }
}
