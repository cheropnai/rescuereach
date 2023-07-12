import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rescuereach/services/reports/report.dart';
import 'package:rescuereach/services/reports/report_storage_constants.dart';

import 'cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('reports');

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException;
    }
  }

  Future<void> deleteNote(
      {required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException;
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException;
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
        documentId: fetchedNote.id, ownerUserId: ownerUserId, text: '');
  }

  //creating a singleton
  //first create a private constructor
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();
  //then create a factory constructor
  factory FirebaseCloudStorage() => _shared;
}
