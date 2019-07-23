import 'local/status_source.dart';
import '../model/status.dart' show MyStatus;

import '../common/saga_logger.dart';

class StatusRepository {
  final StatusSource _localDataSource;

  StatusRepository({StatusSource local}) : _localDataSource = (local == null) ? StatusSource() : local;

  Future<List<MyStatus>> findAll() async {
    return await _localDataSource.findAll();
  }

  Future<MyStatus> find(String charName) async {
    SagaLogger.d('$charName のmystatusをfindします');
    return await _localDataSource.find(charName) ?? MyStatus.empty(charName);
  }

  Future<void> save(MyStatus status) async {
    return _localDataSource.save(status);
  }
}
