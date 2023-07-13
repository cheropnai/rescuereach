import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class UsersCollection {
  Future<void> createUserCollection() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final userEmail = currentUser.email;
      await firestore
          .collection('users')
          .doc(currentUser.uid)
          .set({'uid': userId, 'email': userEmail});
      print('creating user collection in Firestore');
    } else {
      print('No current user logged in.');
    }
  }
}