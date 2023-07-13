import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  //creating instances of firebaseAuth, google and apple
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AppleAuthProvider appleauth = AppleAuthProvider();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  //haserror, errocode,provider,uid,name,urole
  bool _hasError = false;
  bool get hasError => _hasError;
  String? _errorCode;
  String? get errorCode => _errorCode;
  String? _provider;
  String? get provider => _provider;
  String? _uid;
  String? get uid => _uid;
  String? _name;
  String? get name => _name;
  String? _email;
  String? get email => _email;
  String? _imageUrl;
  String? get imageUrl => _imageUrl;
  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("sign_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  //SignIn with google account
  Future<void> signInWithGoogle() async {
    print('wacsha uflaalaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();
    print('wacsha ufldddddddddddddddddddddddddddddddda');

    if (googleSignInAccount != null) {
      try {
        print('sending sign in prompt');
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        print('googleSign details tokend gotttttttttttttttttttttttt');
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        print('sending credentials rto firebase.comdddddddddddddd');
        final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
        print(userCredential);
        final User userDetails = userCredential.user!;

        _name = userDetails.displayName;
        _email = userDetails.email;
        print(_name);
        print(_email);
        _uid = userDetails.uid;
        _imageUrl = userDetails.photoURL;
        _provider = "google";
        //_isSignedIn = true;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credentials":
            _errorCode =
            "You already have an account with us. Sign in with a different email.";
            _hasError = true;
            break;
          case "sign_in_failed":
            _errorCode = "Sign in cancelled/failed.";
            break;
          default:
            _errorCode = "Some unexpected error occurred: ${e.message}";
            _hasError = true;
            break;
        }
        notifyListeners();
      } catch (e) {
        print('did not sign in: kcbkhkujcsiha9ofah9awh');
        print(e);
      }
    } else {
      _hasError = true;
      print('Account is null. exrctgbjnjkvcxyrtyjfv  yrx rfufcyj ');
      notifyListeners();
    }
  }

  //create entry for cloud firestore
  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => (
    _uid = snapshot['uid'],
    _name = snapshot['name'],
    _email = snapshot['email'],
    _imageUrl = snapshot['image_url'],
    _provider = snapshot['provider'],
    ));
  }

  Future saveDataToFireStore() async {
    final DocumentReference r =
    FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "image_url": _imageUrl,
      "provider": _provider,
    });
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageUrl!);
    await s.setString('provider', _provider!);
    notifyListeners();
  }

  // check if the user exists in cloud firestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
    await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      print('existing user');
      return true;
    } else {
      print('new user');
      return false;
    }
  }

  //sign out function
  Future usersignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();
    clearStoredData();
    //clear all the storage information
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }
}