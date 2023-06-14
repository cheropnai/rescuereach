import 'package:flutter/material.dart';
import 'package:rescuereach/components/my_textfield.dart';
import 'package:rescuereach/components/my_button.dart';
import 'package:rescuereach/components/square_tile.dart';

class loginView extends StatelessWidget {
  loginView({super.key});

  //Text editing controllers.
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method. //@Monicah you can work on this sign in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 191, 166, 233),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 50),
              //logo
              const Icon(
                Icons.local_car_wash,
                size: 100,
              ),

              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),

              //username
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 25),
              //password
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 25),
              //forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // sign in button
              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 25),

              //or continue with.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'or continue with',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(imagePath: 'lib/images/google-logo-9824.png'),

                  const SizedBox(width: 25),

                  //apple button
                  SquareTile(imagePath: 'lib/images/png-apple-logo-9723.png'),
                ],
              ),

              const SizedBox(height: 50),

              // not a member register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Register now',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
