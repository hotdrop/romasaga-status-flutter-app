import 'package:flutter/foundation.dart' as foundation;

import '../view_state.dart';

import '../../model/character.dart';
import '../../model/style.dart';
import '../../model/status.dart';
import '../../model/stage.dart';
import '../../model/weapon.dart';

import '../../data/character_repository.dart';
import '../../data/my_status_repository.dart';
import '../../data/stage_repository.dart';

import '../../common/rs_strings.dart';
import '../../common/rs_logger.dart';

class CharDetailViewModel extends foundation.ChangeNotifier with ViewState {
  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;
  final MyStatusRepository _myStatusRepository;

  final Character _character;

  CharDetailViewModel(this._character, {CharacterRepository characterRepo, StageRepository stageRepo, MyStatusRepository statusRepo})
      : _characterRepository = (characterRepo == null) ? CharacterRepository() : characterRepo,
        _stageRepository = (stageRepo == null) ? StageRepository() : stageRepo,
        _myStatusRepository = (statusRepo == null) ? MyStatusRepository() : statusRepo;

  List<Stage> _stages;
  List<Stage> get stages => _stages;

  Style _selectedStyle;
  Stage _selectedStage;

  void load() async {
    RSLogger.d('ロードします。');
    onLoading();

    _stages = await _stageRepository.load();
    _selectedStage = _stages.first;

    if (_character.styles.isEmpty) {
      RSLogger.d('キャラクターのスタイルが未取得なので取得します。');
      final styles = await _characterRepository.findStyles(_character.id);
      _character.addStyles(styles);
    }

    _selectedStyle = _character.getSelectedStyle();

    onSuccess();
    notifyListeners();
  }

  ///
  /// characterオブジェクトはViewクラスからViewModelに渡されるので当然Viewクラスでも参照できる
  /// ただ、どっちからも参照する実装は嫌だったので全てViewModelクラスを経由するようにしている。
  ///
  String get characterName => _character.name;
  WeaponType get weaponType => _character.weaponType;
  WeaponCategory get weaponCategory => _character.weaponCategory;
  MyStatus get myStatus => _character.myStatus;
  String get selectedRank => _character.selectedStyleRank;
  Style style(String rank) => _character.getStyle(rank);

  String get selectedIconFileName => _selectedStyle.iconFilePath;
  String get selectedStyleRank => _selectedStyle.rank;
  String get selectedStyleTitle => _selectedStyle.title;

  void onSelectRank(String rank) {
    _selectedStyle = _character.getStyle(rank);
    notifyListeners();
  }

  List<String> getAllRanks() {
    final ranks = _character.styles.map((style) => style.rank).toList();
    return ranks..sort((s, t) => s.compareTo(t));
  }

  String getSelectedStageName() {
    return _selectedStage?.name ?? null;
  }

  void onSelectStage(String stageName) {
    _selectedStage = _stages.firstWhere((s) => s.name == stageName);
    notifyListeners();
  }

  int addUpperLimit(int status) => status + _selectedStage.limit;

  int getStatusUpperLimit(String statusName) {
    var targetStatus;
    switch (statusName) {
      case RSStrings.StrName:
        targetStatus = _selectedStyle?.str;
        break;
      case RSStrings.VitName:
        targetStatus = _selectedStyle?.vit;
        break;
      case RSStrings.DexName:
        targetStatus = _selectedStyle?.dex;
        break;
      case RSStrings.AgiName:
        targetStatus = _selectedStyle?.agi;
        break;
      case RSStrings.IntName:
        targetStatus = _selectedStyle?.intelligence;
        break;
      case RSStrings.SpiName:
        targetStatus = _selectedStyle?.spirit;
        break;
      case RSStrings.LoveName:
        targetStatus = _selectedStyle?.love;
        break;
      case RSStrings.AttrName:
        targetStatus = _selectedStyle?.attr;
        break;
      default:
        targetStatus = 0;
        break;
    }

    if (targetStatus == null) {
      return 0;
    }
    return targetStatus + _selectedStage.limit;
  }

  void refreshStatus() async {
    _character.myStatus = await _myStatusRepository.find(_character.id);
    notifyListeners();
  }

  void saveCurrentSelectStyle() async {
    RSLogger.d('表示ランクを ${_selectedStyle.rank} にします。');
    _character.selectedStyleRank = _selectedStyle.rank;
    _character.selectedIconFilePath = _selectedStyle.iconFilePath;
    await _characterRepository.saveSelectedRank(_character.id, _selectedStyle.rank, _selectedStyle.iconFilePath);
  }

  void saveHaveCharacter(bool haveChar) async {
    RSLogger.d('このキャラの保持を $haveChar にします。');
    _character.myStatus.have = haveChar;
    await _myStatusRepository.save(_character.myStatus);
    notifyListeners();
  }

  void saveFavorite(bool favorite) async {
    RSLogger.d('お気に入りを $favorite にします。');
    _character.myStatus.favorite = favorite;
    await _myStatusRepository.save(_character.myStatus);
    notifyListeners();
  }
}
