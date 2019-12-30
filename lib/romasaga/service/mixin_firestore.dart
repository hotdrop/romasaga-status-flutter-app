import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/status.dart';

class RSFirestoreMixin {
  Future<void> setMyStatuses(List<MyStatus> myStatuses, String uid) async {
    for (var myStatus in myStatuses) {
      await Firestore().collection(_rootCollectionName).document(uid).collection(_statusCollectionName).document(myStatus.id.toString()).setData(_toMap(myStatus));
    }
  }

  static final String _rootCollectionName = 'backup';
  static final String _statusCollectionName = 'statuses';

  Map<String, dynamic> _toMap(MyStatus myStatus) {
    return <String, dynamic>{
      'hp': myStatus.hp,
      'str': myStatus.str,
      'vit': myStatus.vit,
      'dex': myStatus.dex,
      'agi': myStatus.agi,
      'intelligence': myStatus.intelligence,
      'spirit': myStatus.spirit,
      'love': myStatus.love,
      'attr': myStatus.attr,
      'haveChar': myStatus.have,
      'favorite': myStatus.favorite,
    };
  }

  Future<List<MyStatus>> getMyStatues(String uid) async {
    final snapshots = await Firestore().collection(_rootCollectionName).document(uid).collection(_statusCollectionName).getDocuments();
    final results = <MyStatus>[];
    for (var doc in snapshots.documents) {
      results.add(_toMyStatus(doc));
    }
    return results;
  }

  MyStatus _toMyStatus(DocumentSnapshot doc) {
    return MyStatus(
      int.parse(doc.documentID),
      doc['hp'] as int,
      doc['str'] as int,
      doc['vit'] as int,
      doc['dex'] as int,
      doc['agi'] as int,
      doc['intelligence'] as int,
      doc['spirit'] as int,
      doc['love'] as int,
      doc['attr'] as int,
      doc['haveChar'] as bool,
      doc['favorite'] as bool,
    );
  }
}
