import 'package:flutter/material.dart';

class loginView extends StatelessWidget {
  const loginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 191, 166, 233),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Icon(
                  Icons.lock,
                  size: 100,
                ),
                SizedBox(
                  height: 50,
                ),
                const Text(
                  'welcome back',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow)),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
