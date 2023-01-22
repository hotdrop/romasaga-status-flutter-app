import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rsapp/data/stage_repository.dart';

final stageProvider = NotifierProvider<StageNotifier, Stage>(StageNotifier.new);

class StageNotifier extends Notifier<Stage> {
  @override
  Stage build() {
    return Stage.empty();
  }

  Future<void> onLoad() async {
    state = await ref.read(stageRepositoryProvider).find();
  }

  Future<void> save(Stage newStage) async {
    await ref.read(stageRepositoryProvider).save(newStage);
    onLoad();
  }
}

class Stage {
  const Stage({required this.name, required this.hpLimit, required this.statusLimit});

  factory Stage.empty() {
    return const Stage(name: '1章VH6', hpLimit: 790, statusLimit: 0);
  }

  final String name;
  final int hpLimit;
  final int statusLimit;
}
