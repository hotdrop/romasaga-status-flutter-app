import 'local/my_status_source.dart';
import '../model/status.dart' show MyStatus;

import '../common/saga_logger.dart';

class MyStatusRepository {
  final MyStatusSource _localDataSource;

  MyStatusRepository({MyStatusSource local}) : _localDataSource = (local == null) ? MyStatusSource() : local;

  Future<List<MyStatus>> findAll() async {
    return await _localDataSource.findAll();
  }

  Future<MyStatus> find(int id) async {
    return await _localDataSource.find(id) ?? MyStatus.empty(id);
  }

  Future<void> save(MyStatus status) async {
    return _localDataSource.save(status);
  }
}
