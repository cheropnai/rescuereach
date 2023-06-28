import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rescuereach/views/login_view.dart';

import '../services/auth/auth_exceptions.dart';
import 'login_view (2).dart';

class PhoneVerificationPage extends StatefulWidget {
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();

  bool _showVerificationField = false;
  String? _verificationId;

  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = _phoneNumberController.text.trim();

    // Perform any validation checks on the phone number input

    // Request phone number verification
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically handle verification if the device auto-retrieves the verification code
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Move to the next screen or perform any desired actions
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          navigateToLogin();
        } else {
          throw UserNotLoggedInException();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store the verification ID and show the verification field
        setState(() {
          _showVerificationField = true;
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto-retrieval timeout
        print('Verification code retrieval timed out');
      },
    );
  }

  Future<void> _verifyVerificationCode() async {
    String verificationCode = _verificationCodeController.text.trim();

    // Perform any validation checks on the verification code input

    if (_verificationId != null) {
      // Create PhoneAuthCredential using the verification code and verification ID
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: verificationCode,
      );

      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Move to the next screen or perform any desired actions
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        navigateToLogin();
      } else {
        throw UserNotLoggedInException();
      }
    } else {
      // Verification ID is not available
      throw Exception('Verification ID not found');
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16.0),
            Visibility(
              visible: _showVerificationField,
              child: TextField(
                controller: _verificationCodeController,
                decoration:
                    const InputDecoration(labelText: 'Verification Code'),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _showVerificationField
                  ? _verifyVerificationCode
                  : _verifyPhoneNumber,
              child: Text(_showVerificationField ? 'Verify Code' : 'send code'),
            ),
          ],
        ),
      ),
    );
  }
}
