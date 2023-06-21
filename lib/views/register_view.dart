import 'package:flutter/material.dart';
import 'package:rescuereach/components/my_textfield.dart';
import 'package:rescuereach/components/my_button.dart';
import 'package:rescuereach/components/square_tile.dart';

class RegisterView extends StatefulWidget {
  RegisterView({required Key key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _contacts = <String>[];
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneControllers = <TextEditingController>[]; // Store the controllers for each contact

  void _addContact() {
    setState(() {
      _contacts.add('');
      phoneControllers.add(TextEditingController()); // Add a new controller for each contact
    });
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    for (var controller in phoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 191, 166, 233),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  const Icon(
                    Icons.local_car_wash,
                    size: 100,
                  ),
                  SizedBox(height: 25),
                  const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 25),
                  MyTextField(
                    controller: firstNameController,
                    hintText: 'First Name',
                    obscureText: false,
                  ),
                  MyTextField(
                    controller: lastNameController,
                    hintText: 'Last Name',
                    obscureText: false,
                  ),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  ..._contacts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = phoneControllers[index];
                    return MyTextField(
                      controller: controller,
                      hintText: 'Contact ${index + 1}',
                      obscureText: false,
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Add Contact'),
                    onPressed: _contacts.length >= 6 ? null : _addContact,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Register'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
