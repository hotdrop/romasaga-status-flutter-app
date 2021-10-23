import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/json/stages_json.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/service/rs_service.dart';

///
/// TODO このAPIいらない。ステージ情報は可変に設定できるようにする
/// ただ、リファクタと機能改修を同時にやるとしぬので一旦全部移行だけしてしまう。
///

final stageApiProvider = Provider((ref) => _StageApi(ref.read));

class _StageApi {
  const _StageApi(this._read);

  final Reader _read;

  Future<List<Stage>> findAll() async {
    String json = await _read(rsServiceProvider).readStagesJson();
    return StagesJson.parse(json);
  }
}
