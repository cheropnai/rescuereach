import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rescuereach/provider/internet_provider.dart';
import 'package:rescuereach/provider/sign_in_provider.dart';
import 'package:rescuereach/screens/home_screen.dart';
import 'package:rescuereach/utils/next_screen.dart';
import 'package:rescuereach/utils/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:provider/provider.dart';

import '../utils/config.dart';

class logInScreen extends StatefulWidget {
  const logInScreen({super.key});

  @override
  State<logInScreen> createState() => _logInScreenState();
}

class _logInScreenState extends State<logInScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController appleController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
            top: 90,
            bottom: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(Config.rescue_icon),
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "RescueReach",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Your Safety pal',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedLoadingButton(
                      onPressed: () {
                        handleGoogleSignIn();
                      },
                      controller: googleController,
                      successColor: Colors.green,
                      width: MediaQuery.of(context).size.width * 0.80,
                      elevation: 0,
                      borderRadius: 25,
                      child: const Wrap(
                        children: [
                          // Icon(
                          //   FontAwesomeIcons.google,
                          //   size: 20,
                          //   color: Colors.white,
                          // ),
                          Image(
                            image: AssetImage(Config.app_icon),
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),

                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "continue with google",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )
                        ],
                      ),
                      color: const Color.fromARGB(255, 98, 172, 232)),
                  const SizedBox(
                    height: 5,
                  ),
                  RoundedLoadingButton(
                    onPressed: () {},
                    controller: appleController,
                    successColor: Colors.green,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    child: Wrap(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'log in',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    ),
                    color: Color.fromARGB(255, 220, 49, 155),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//handling google sign in
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackbar(context, "check your internet connection", Colors.pink);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          print('The sign in failed');
          openSnackbar(context, sp.errorCode.toString(), Colors.pink);
          googleController.reset();
        } else {
          sp.checkUserExists().then((value) async {
            if (value == true) {
              //user exists
            } else {
              //does not exist
              sp.saveDataToFireStore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            }
          });
          openSnackbar(context, "signed in", Colors.green);
          googleController.reset();
        }
      });
    }
  }

  //handle after sign in
  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 8000)).then((value) {
      nextScreenReplacement(context, const homeScreen());
    });
  }
}
