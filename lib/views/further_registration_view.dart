import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rescuereach/components/my_button_register.dart';
import 'package:rescuereach/services/auth/bloc/auth_bloc.dart';
import 'package:rescuereach/services/auth/bloc/auth_event.dart';
import 'package:rescuereach/services/auth/bloc/auth_state.dart';

class RegisterFurther extends StatefulWidget {
  const RegisterFurther({Key? key}) : super(key: key);

  @override
  State<RegisterFurther> createState() => RegisterFurtherState();
}

class RegisterFurtherState extends State<RegisterFurther> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _rolesController;

  final List<String> roleOptions = [
    'User',
    'Mentor',
    'Support',
    'Organization',
    'Admin',
  ];
  String? selectedRole;

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _rolesController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _rolesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = _phoneNumberController.text;
      final role = selectedRole!;
      context.read<AuthBloc>().add(AuthEventFurtherRegistration(phoneNumber, role));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 191, 166, 233),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.local_car_wash,
                  size: 100,
                ),
                const Text(
                  'Enter Your Details Here',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter your phone number',
                      hintStyle: TextStyle(color: Colors.grey),
                      helperText: 'A valid Phone Number e.g., +25479856724',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone number is required';
                      }
                      // Add any other custom validation logic if needed
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Select a role',
                      hintStyle: TextStyle(color: Colors.grey),
                      helperText: 'Choose one of the available roles',
                    ),
                    items: roleOptions
                        .map((role) => DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Role is required';
                      }
                      // Add any other custom validation logic if needed
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthStateRegistering) {
                      // Handle registering state if needed
                    }
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return state is AuthStateLoading
                          ? const CircularProgressIndicator()
                          : MyButtonRegister(
                              onTap: _submitForm,
                            );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
