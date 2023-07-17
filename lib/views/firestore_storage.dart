import 'package:rescuereach/services/auth/firebase_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/reports/cloud_storage_exceptions.dart';

class FirestoreStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createSession(String? className, int major, int minor) async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    DocumentReference docRef = _firestore.collection('sessions').doc();
    await docRef.set({
      'name': className,
      'major': major,
      'minor': minor,
      'created': DateTime.now(),
      'createdBy': currentUser.id,
    });
  }

  Future<void> createAttendee(String sessionId) async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    await _firestore
        .collection('attendees')
        .doc(sessionId)
        .collection('attended')
        .doc()
        .set({
      'userId': currentUser.id,
      'time': DateTime.now(),
    });
  }

  Future<void> createUser(
      String school, String course, String year, String group) async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    await _firestore.collection('users').doc(currentUser.id).set({
      'school': school,
      'course': course,
      'year': year,
      'group': group,
    });
  }

  Future<void> addDetails(
    String key1,
    String value1,
    BuildContext context, {
    String? key2,
    String? value2,
    String? key3,
    String? value3,
    String? key4,
    String? value4,
    String? key5,
    String? value5,
  }) async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    Map<String, dynamic> data = {
      key1: value1,
    };
    if (key2 != null && value2 != null) {
      data[key2] = value2;
    }
    if (key3 != null && value3 != null) {
      data[key3] = value3;
    }
    if (key4 != null && value4 != null) {
      data[key4] = value4;
    }
    if (key5 != null && value5 != null) {
      data[key5] = value5;
    }
    await _firestore
        .collection('users')
        .doc(currentUser.id)
        .update(data)
        .then((_) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('User document created successfully!'),
        ),
      );
    }).catchError((error) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to create user document: $error'),
        ),
      );
    });
  }}