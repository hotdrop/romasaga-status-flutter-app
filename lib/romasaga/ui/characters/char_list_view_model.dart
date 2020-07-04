import 'package:rsapp/romasaga/data/character_repository.dart';
import 'package:rsapp/romasaga/data/my_status_repository.dart';
import 'package:rsapp/romasaga/model/character.dart';
import 'package:rsapp/romasaga/common/rs_logger.dart';
import 'package:rsapp/romasaga/ui/change_notifier_view_model.dart';

class CharListViewModel extends ChangeNotifierViewModel {
  CharListViewModel._(this._characterRepository, this._myStatusRepository);

  factory CharListViewModel.create() {
    return CharListViewModel._(
      CharacterRepository.create(),
      MyStatusRepository.create(),
    );
  }

  final CharacterRepository _characterRepository;
  final MyStatusRepository _myStatusRepository;

  List<Character> _characters;
  OrderType selectedOrderType = OrderType.status;

  ///
  /// このViewModelを使うときに必ず呼ぶ
  ///
  Future<void> load() async {
    await run(
      label: 'キャラ一覧のロード処理',
      block: () async {
        _characters = await _characterRepository.findAll();
        await _loadMyStatuses();
        orderBy(OrderType.status);
      },
    );
  }

  List<Character> findAll() {
    return _characters;
  }

  List<Character> findFavorite() {
    final characters = _characters.where((c) => c.myStatus.favorite).toList();
    return characters.isEmpty ? [] : characters;
  }

  List<Character> findStatusUpEvent() {
    final characters = _characters.where((c) => c.statusUpEvent).toList();
    return characters.isEmpty ? [] : characters;
  }

  List<Character> findHaveCharacter() {
    final characters = _characters.where((c) => c.myStatus.have).toList();
    return characters.isEmpty ? [] : characters;
  }

  List<Character> findNotHaveCharacter() {
    final characters = _characters.where((c) => !c.myStatus.have).toList();
    return characters.isEmpty ? [] : characters;
  }

  void orderBy(OrderType order) {
    switch (order) {
      case OrderType.hp:
        _characters.sort((c1, c2) => c2.myStatus.hp.compareTo(c1.myStatus.hp));
        break;
      case OrderType.production:
        _characters.sort((c1, c2) => c1.id.compareTo(c2.id));
        break;
      default:
        _characters.sort((c1, c2) => c2.myStatus.sumWithoutHp().compareTo(c1.myStatus.sumWithoutHp()));
        break;
    }
    selectedOrderType = order;
    notifyListeners();
  }

  ///
  /// ステータス情報を更新する。
  /// 詳細画面から戻ってきたときに使う。
  ///
  Future<void> refreshMyStatuses() async {
    await _loadMyStatuses();
    notifyListeners();
  }

  Future<void> _loadMyStatuses() async {
    RSLogger.d("登録ステータスをロードします。");
    final myStatuses = await _myStatusRepository.findAll();

    RSLogger.d("登録ステータスのロードが完了しました。");
    if (myStatuses.isNotEmpty) {
      for (var status in myStatuses) {
        RSLogger.d("ステのid=${status.id}");
        final targetStatus = _characters.firstWhere((character) => character.id == status.id);
        targetStatus.myStatus = status;
      }
    }
  }
}

enum OrderType { status, hp, production }
