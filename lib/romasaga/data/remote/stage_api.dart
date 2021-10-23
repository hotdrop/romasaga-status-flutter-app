import 'package:rsapp/romasaga/data/json/stages_json.dart';
import 'package:rsapp/models/stage.dart';
import 'package:rsapp/romasaga/service/rs_service.dart';

class StageApi {
  const StageApi._(this._rsService);

  factory StageApi.create() {
    return StageApi._(RSService.getInstance());
  }

  final RSService _rsService;

  Future<List<Stage>> findAll() async {
    String json = await _rsService.readStagesJson();
    return StagesJson.parse(json);
  }
}
