class Stage {
  const Stage(this.name, this.limit, this.order, {this.id});

  final String name;
  final int limit;
  final int order;

  // IDはデータ保存時に発行するので、ユーザーが入力してからデータ登録完了するまではidがない状態になる
  final int? id;
}
