import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/character_repository.dart';
import 'package:rsapp/romasaga/data/my_status_repository.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/ui/change_notifier_view_model.dart';

class DashboardViewModel extends ChangeNotifierViewModel {
  DashboardViewModel._(this._characterRepository, this._myStatusRepository);

  factory DashboardViewModel.create() {
    return DashboardViewModel._(CharacterRepository.create(), MyStatusRepository.create());
  }

  final CharacterRepository _characterRepository;
  final MyStatusRepository _myStatusRepository;

  List<Character> _characters;

  Future<void> load() async {
    await run(
      label: 'ダッシュボードのキャラ一覧ロード処理',
      block: () async {
        final chars = await _characterRepository.findAll();
        _characters = await _loadMyStatuses(chars);
      },
    );
  }

  Future<List<Character>> _loadMyStatuses(List<Character> argCharacters) async {
    final myStatuses = await _myStatusRepository.findAll();

    RSLogger.d("詳細なステータスをロードします。");
    final characters = argCharacters;
    if (myStatuses.isNotEmpty) {
      for (var status in myStatuses) {
        characters.firstWhere((c) => c.id == status.id).myStatus = status;
      }
    }

    return characters;
  }

  int get favoriteNum => _characters.where((c) => c.myStatus.favorite).toList().length;

  int get haveNum => _characters.where((c) => c.myStatus.have).toList().length;

  int get allCharNum => _characters.length;

  List<Character> getStrTop5() {
    _characters.sort((a, b) => b.myStatus.str.compareTo(a.myStatus.str));
    return _characters.take(5).toList();
  }

  List<Character> getVitTop5() {
    _characters.sort((a, b) => b.myStatus.vit.compareTo(a.myStatus.vit));
    return _characters.take(5).toList();
  }

  List<Character> getDexTop5() {
    _characters.sort((a, b) => b.myStatus.dex.compareTo(a.myStatus.dex));
    return _characters.take(5).toList();
  }

  List<Character> getAgiTop5() {
    _characters.sort((a, b) => b.myStatus.agi.compareTo(a.myStatus.agi));
    return _characters.take(5).toList();
  }

  List<Character> getIntTop5() {
    _characters.sort((a, b) => b.myStatus.intelligence.compareTo(a.myStatus.intelligence));
    return _characters.take(5).toList();
  }

  List<Character> getSpiritTop5() {
    _characters.sort((a, b) => b.myStatus.spirit.compareTo(a.myStatus.spirit));
    return _characters.take(5).toList();
  }

  List<Character> getLoveTop5() {
    _characters.sort((a, b) => b.myStatus.love.compareTo(a.myStatus.love));
    return _characters.take(5).toList();
  }

  List<Character> getAttrTop5() {
    _characters.sort((a, b) => b.myStatus.attr.compareTo(a.myStatus.attr));
    return _characters.take(5).toList();
  }
}
