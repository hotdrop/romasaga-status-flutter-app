class Stage {
  const Stage({required this.name, required this.hpLimit, required this.statusLimit});

  factory Stage.empty() {
    return const Stage(name: '1章VH6', hpLimit: 790, statusLimit: 0);
  }

  final String name;
  final int hpLimit;
  final int statusLimit;
}
