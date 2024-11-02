import 'package:flutter/material.dart';

import '../functions/auth_functions.dart';  // Receiver-related auth functions should be implemented here
import 'receiver_dashboard.dart';  // Ensure Receiver Dashboard screen is available

class ReceiverSignupPage extends StatefulWidget {
  const ReceiverSignupPage({Key? key}) : super(key: key);

  @override
  State<ReceiverSignupPage> createState() => _ReceiverSignupPageState();
}

class _ReceiverSignupPageState extends State<ReceiverSignupPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String receiverName = '';
  String address = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/images2.jpg'), // Your background image
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black54, // Optional dark overlay for better readability
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Two-column layout
          Center(
            child: Container(
              width: screenWidth * 0.8, // Make sure the content doesn't stretch across the entire screen
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Side: Receiver Functions Description
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Become a Food Receiver',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'As a registered food receiver, you can:',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '- Receive food donations from nearby restaurants.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '- Get notified when food is available for pickup or delivery.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '- Manage your pickup schedule to reduce waste and help those in need.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Join our network and help reduce food wastage!',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right Side: Signup Form
                  Expanded(
                    flex: 1,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Receiver Signup',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            key: const ValueKey('receiverName'),
                            decoration: InputDecoration(
                              labelText: 'Receiver Name',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Receiver Name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              receiverName = value!;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('receiverAddress'),
                            decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              address = value!;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('receiverPhone'),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.length < 10) {
                                return 'Please enter a valid Phone Number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phone = value!;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('receiverEmail'),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid Email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value!;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('password'),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              password = value!;
                            },
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final userCredential = await ReceiverAuthServices.signupReceiver(
                                      email, password, receiverName,phone as BuildContext,address, context);
                                  if (userCredential != null) {
                                    // Navigate to Receiver Dashboard
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ReceiverDashboard(),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Signup',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
