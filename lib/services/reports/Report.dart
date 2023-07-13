import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'report_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String timeStamp;

 const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.timeStamp,
  });
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        timeStamp =
            (snapshot.data()[timeStampField] as Timestamp).toDate().toString();
}

    // DateTime dateTime =serverTimestamp.toDate();



//   factory CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
//     final timeStamp = snapshot.data()[timeStampField] as String;
//     return CloudNote(
//       documentId: snapshot.id,
//       ownerUserId: snapshot.data()[ownerUserIdFieldName],
//       text: snapshot.data()[textFieldName],
//       timeStamp: timeStamp,
//     );
//   }
// }
