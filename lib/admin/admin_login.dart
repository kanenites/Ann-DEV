import 'package:flutter/material.dart';
import '../functions/auth_functions.dart';
import 'admin_dashboard.dart';

class AdminSignupScreen extends StatefulWidget {
  const AdminSignupScreen({Key? key});

  @override
  State<AdminSignupScreen> createState() => _AdminSignupScreenState();
}

class _AdminSignupScreenState extends State<AdminSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String restaurantName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Admin Signup'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  key: const ValueKey('restaurantName'),
                  decoration: const InputDecoration(
                    hintText: 'Enter Restaurant Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter restaurant name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      restaurantName = value!;
                    });
                  },
                ),
                TextFormField(
                  key: const ValueKey('email'),
                  decoration: const InputDecoration(
                    hintText: 'Enter Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      email = value!;
                    });
                  },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final userCredential = await AdminAuthServices.signupAdmin(
                            email, password, restaurantName, context);
                        if (userCredential != null) {
                          // Navigate to admin dashboard
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminDashboard()),
                          );
                        }
                      }
                    },
                    child: const Text('Signup'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
