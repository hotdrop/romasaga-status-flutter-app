import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rsapp/models/status.dart';

mixin RSFirestoreMixin {
  static const String _rootCollectionName = 'backup';
  static const String _statusCollectionName = 'statuses';

  Future<void> setMyStatuses(List<MyStatus> myStatuses, String uid) async {
    for (var myStatus in myStatuses) {
      await FirebaseFirestore.instance //
          .collection(_rootCollectionName)
          .doc(uid)
          .collection(_statusCollectionName)
          .doc(myStatus.id.toString())
          .set(_toMap(myStatus));
    }
  }

  Map<String, dynamic> _toMap(MyStatus myStatus) {
    return <String, dynamic>{
      'hp': myStatus.hp,
      'str': myStatus.str,
      'vit': myStatus.vit,
      'dex': myStatus.dex,
      'agi': myStatus.agi,
      'intelligence': myStatus.inte,
      'spirit': myStatus.spi,
      'love': myStatus.love,
      'attr': myStatus.attr,
      'favorite': myStatus.favorite,
    };
  }

  Future<List<MyStatus>> getMyStatues(String uid) async {
    final snapshots = await FirebaseFirestore.instance //
        .collection(_rootCollectionName)
        .doc(uid)
        .collection(_statusCollectionName)
        .get();

    final results = <MyStatus>[];
    for (var doc in snapshots.docs) {
      results.add(_toMyStatus(doc));
    }
    return results;
  }

  MyStatus _toMyStatus(DocumentSnapshot doc) {
    return MyStatus(
      int.parse(doc.id),
      doc.get('hp') as int,
      doc.get('str') as int,
      doc.get('vit') as int,
      doc.get('dex') as int,
      doc.get('agi') as int,
      doc.get('intelligence') as int,
      doc.get('spirit') as int,
      doc.get('love') as int,
      doc.get('attr') as int,
      doc.get('favorite') as bool,
    );
  }
}
