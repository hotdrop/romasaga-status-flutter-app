import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/data/character_repository.dart';
import 'package:rsapp/romasaga/data/my_status_repository.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/model/ranking_character.dart';
import 'package:rsapp/romasaga/ui/change_notifier_view_model.dart';

class DashboardViewModel extends ChangeNotifierViewModel {
  DashboardViewModel._(this._characterRepository, this._myStatusRepository);

  factory DashboardViewModel.create() {
    return DashboardViewModel._(CharacterRepository.create(), MyStatusRepository.create());
  }

  final CharacterRepository _characterRepository;
  final MyStatusRepository _myStatusRepository;

  List<Character> _characters;

  RankingCharacter _topCharacter;

  RankingCharacter get topCharacter => _topCharacter;

  List<Character> _strTop5;

  List<Character> get strTop5 => _strTop5;

  List<Character> _vitTop5;

  List<Character> get vitTop5 => _vitTop5;

  List<Character> _dexTop5;

  List<Character> get dexTop5 => _dexTop5;

  List<Character> _agiTop5;
  List<Character> get agiTop5 => _agiTop5;

  List<Character> _intTop5;
  List<Character> get intTop5 => _intTop5;

  List<Character> _spiritTop5;
  List<Character> get spiritTop5 => _spiritTop5;

  List<Character> _loveTop5;
  List<Character> get loveTop5 => _loveTop5;

  List<Character> _attrTop5;
  List<Character> get attrTop5 => _attrTop5;

  Future<void> load() async {
    await run(
      label: 'ダッシュボードのキャラ一覧ロード処理',
      block: () async {
        final chars = await _characterRepository.findAll();
        _characters = await _loadMyStatuses(chars);

        // いちいちソートしてトップ5を取得すると効率悪いのでload時に取得する。
        takeStatusTop5Characters(_characters);
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

  void takeStatusTop5Characters(List<Character> c) {
    c.sort((a, b) => b.myStatus.str.compareTo(a.myStatus.str));
    _strTop5 = c.take(5).toList();

    c.sort((a, b) => b.myStatus.vit.compareTo(a.myStatus.vit));
    _vitTop5 = c.take(5).toList();

    c.sort((a, b) => b.myStatus.dex.compareTo(a.myStatus.dex));
    _dexTop5 = c.take(5).toList();

    c.sort((a, b) => b.myStatus.agi.compareTo(a.myStatus.agi));
    _agiTop5 = c.take(5).toList();

    c.sort((a, b) => b.myStatus.intelligence.compareTo(a.myStatus.intelligence));
    _intTop5 = c.take(5).toList();

    c.sort((a, b) => b.myStatus.spirit.compareTo(a.myStatus.spirit));
    _spiritTop5 = c.take(5).toList();

    c.sort((a, b) => b.myStatus.love.compareTo(a.myStatus.love));
    _loveTop5 = c.take(5).toList();

    c.sort((a, b) => b.myStatus.attr.compareTo(a.myStatus.attr));
    _attrTop5 = c.take(5).toList();

    _takeTopCharacter();
  }

  void _takeTopCharacter() {
    final ranking = Ranking(
      strTop5,
      vitTop5,
      dexTop5,
      agiTop5,
      intTop5,
      spiritTop5,
      loveTop5,
      attrTop5,
    );

    _topCharacter = ranking.getTop();
    RSLogger.d('ランキングトップは${_topCharacter.character.name}です。ポイント${_topCharacter.rankingPoint()}');
  }
}
