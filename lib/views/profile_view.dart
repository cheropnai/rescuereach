import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescuereach/services/auth/bloc/auth_bloc.dart';
import 'package:rescuereach/views/welcome_view.dart';

import '../services/auth/firebase_auth_provider.dart';
import 'firestore_storage.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  final FirestoreStorage _firestoreStorage = FirestoreStorage();
  final FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider();

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    fetchData();
    super.initState();
  }

  void fetchData() async {
    final userId = _firebaseAuthProvider.currentUser!.id;
    DocumentReference docRef =
    FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      DocumentSnapshot docSnapshot = await docRef.get();
      String name = await _firebaseAuthProvider.getDisplayName();
      String email = await _firebaseAuthProvider.getEmail();
      setState(() {
        _nameController.text = name;
        _emailController.text = email;
      });

      if (docSnapshot.exists) {
        Map<String, dynamic> data =
        docSnapshot.data() as Map<String, dynamic>;

        setState(() {
          // Update the text controller values with the retrieved data
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        });
      }
    } catch (error) {
      print('Failed to fetch data: $error');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 191, 166, 233),
      appBar: AppBar(
        title: const Text('Profile Setup'),
        backgroundColor: const Color.fromRGBO(224, 176, 255, 1),
      ),
      body: ListView(
        children: [
          Form(
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Update your details.'),
                  onPressed: () async {
                    final FirebaseFirestore firestore =
                        FirebaseFirestore.instance;
                    final name = _nameController.text;
                    final email = _emailController.text;
                    final phone = _phoneController.text;
                    final user = FirebaseAuth.instance.currentUser!;

                    _firebaseAuthProvider.updateName(name);

                    await firestore.collection('users').doc(user.uid).set({
                      'name': name,
                      'phone': phone,
                      'email': email,
                    });

                    // Navigate to the WelcomeView
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeView(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  const Color.fromRGBO(224, 176, 255, 1)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}