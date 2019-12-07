import 'package:flutter/foundation.dart' as foundation;

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

class CharDetailViewModel extends foundation.ChangeNotifier {
  CharDetailViewModel._(this._character, this._characterRepository, this._stageRepository, this._myStatusRepository);

  factory CharDetailViewModel.create(Character character) {
    return CharDetailViewModel._(character, CharacterRepository(), StageRepository(), MyStatusRepository());
  }

  factory CharDetailViewModel.test(
    Character character,
    CharacterRepository characterRepo,
    StageRepository stageRepo,
    MyStatusRepository statusRepo,
  ) {
    return CharDetailViewModel._(character, characterRepo, stageRepo, statusRepo);
  }

  final CharacterRepository _characterRepository;
  final StageRepository _stageRepository;
  final MyStatusRepository _myStatusRepository;

  final Character _character;

  List<Stage> _stages;
  List<Stage> get stages => _stages ?? [];

  Style _selectedStyle;
  Stage _selectedStage;

  _PageState _pageState = _PageState.loading;
  bool get isLoading => _pageState == _PageState.loading;
  bool get isSuccess => _pageState == _PageState.success;
  bool get isError => _pageState == _PageState.error;

  Future<void> load() async {
    RSLogger.d('キャラ詳細情報をロードします。');
    _pageState = _PageState.loading;
    notifyListeners();

    try {
      _stages = await _stageRepository.load();
      _selectedStage = _stages.first;

      if (_character.styles.isEmpty) {
        RSLogger.d('キャラクターのスタイルが未取得なので取得します。');
        final styles = await _characterRepository.findStyles(_character.id);
        _character.addStyles(styles);
      }

      _selectedStyle = _character.selectedStyle;

      _pageState = _PageState.success;
      notifyListeners();
    } catch (e) {
      RSLogger.e('${_character.name}のロード時にエラーが発生しました。', e);
      _pageState = _PageState.error;
      notifyListeners();
    }
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
  int get myTotalStatus => myStatus.sumWithoutHp();

  String get selectedIconFilePath => _selectedStyle?.iconFilePath ?? 'default';
  String get selectedStyleTitle => _selectedStyle?.title ?? '';

  void onSelectRank(String rank) {
    _selectedStyle = _character.getStyle(rank);
    notifyListeners();
  }

  List<String> getAllRanks() {
    final ranks = _character.styles.map((style) => style.rank).toList();
    return ranks..sort((s, t) => s.compareTo(t));
  }

  String getSelectedStageName() {
    return _selectedStage?.name;
  }

  int getSelectedStageLimit() {
    return _selectedStage.limit ?? 0;
  }

  int getTotalLimitStatusWithSelectedStage() {
    return _selectedStyle.sum() + (8 * _selectedStage.limit);
  }

  void onSelectStage(String stageName) {
    _selectedStage = _stages.firstWhere((s) => s.name == stageName);
    notifyListeners();
  }

  int getStatusLimit(String statusName) {
    int targetStatus;
    switch (statusName) {
      case RSStrings.strName:
        targetStatus = _selectedStyle?.str;
        break;
      case RSStrings.vitName:
        targetStatus = _selectedStyle?.vit;
        break;
      case RSStrings.dexName:
        targetStatus = _selectedStyle?.dex;
        break;
      case RSStrings.agiName:
        targetStatus = _selectedStyle?.agi;
        break;
      case RSStrings.intName:
        targetStatus = _selectedStyle?.intelligence;
        break;
      case RSStrings.spiName:
        targetStatus = _selectedStyle?.spirit;
        break;
      case RSStrings.loveName:
        targetStatus = _selectedStyle?.love;
        break;
      case RSStrings.attrName:
        targetStatus = _selectedStyle?.attr;
        break;
      default:
        targetStatus = null;
        break;
    }

    if (targetStatus == null) {
      return 1;
    }
    return targetStatus + _selectedStage.limit;
  }

  Future<void> refreshStatus() async {
    _character.myStatus = await _myStatusRepository.find(_character.id);
    notifyListeners();
  }

  Future<void> saveCurrentSelectStyle() async {
    RSLogger.d('表示ランクを ${_selectedStyle.rank} にします。');
    _character.selectedStyleRank = _selectedStyle.rank;
    _character.selectedIconFilePath = _selectedStyle.iconFilePath;
    await _characterRepository.saveSelectedRank(_character.id, _selectedStyle.rank, _selectedStyle.iconFilePath);
  }

  Future<void> saveHaveCharacter(bool haveChar) async {
    RSLogger.d('このキャラの保持を $haveChar にします。');
    _character.myStatus.have = haveChar;
    await _myStatusRepository.save(_character.myStatus);
    notifyListeners();
  }

  Future<void> saveFavorite(bool favorite) async {
    RSLogger.d('お気に入りを $favorite にします。');
    _character.myStatus.favorite = favorite;
    await _myStatusRepository.save(_character.myStatus);
    notifyListeners();
  }
}

enum _PageState { loading, success, error }
