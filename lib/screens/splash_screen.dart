import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rescuereach/provider/sign_in_provider.dart';
import 'package:rescuereach/screens/home_screen.dart';
import 'package:rescuereach/screens/login_screen.dart';
import 'package:rescuereach/utils/config.dart';

import '../utils/next_screen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), () {
      sp.isSignedIn == false
          ? nextScreen(context, const logInScreen())
          : nextScreen(context, const homeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Image(
              image: AssetImage(Config.app_icon),
              height: 80,
              width: 80,
            ),
          ),
        ));
  }
}