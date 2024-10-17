import 'package:flutter/material.dart';
import 'package:waste_manage/contributor/contributor_dashboard.dart';

import '../functions/auth_functions.dart';

class ContributorScreen extends StatefulWidget {
  const ContributorScreen({Key? key}) : super(key: key);

  @override
  State<ContributorScreen> createState() => _ContributorScreenState();
}

class _ContributorScreenState extends State<ContributorScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String restaurantName = '';
  String address = '';
  String phone = '';
  bool login = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(login ? 'Login' : 'Signup'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!login)
                  TextFormField(
                    key: ValueKey('restaurantName'),
                    decoration: InputDecoration(
                      hintText: 'Enter Restaurant Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Restaurant Name';
                      }
                      return null; // Return null if validation passes
                    },
                    onSaved: (value) {
                      restaurantName = value!;
                    },
                  ),
                  if (!login)
                  TextFormField(
                    key: ValueKey('address'),
                    decoration: InputDecoration(
                      hintText: 'Enter Restaurant Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Restaurant Address';
                      }
                      return null; 
                    },
                    onSaved: (value) {
                      address = value!;
                    },
                  ),
                  if (!login)
                TextFormField(
                  key: ValueKey('phone'),
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
                  ),
                  validator: (value) {
                    if (value!.length<10) {
                      return 'Please Enter a valid Phone Number';
                    }
                    return null; // Return null if validation passes
                  },
                  onSaved: (value) {
                    phone = value!;
                  },
                ),
                TextFormField(
                  key: ValueKey('email'),
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please Enter a valid Email';
                    }
                    return null; // Return null if validation passes
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                TextFormField(
                  key: ValueKey('password'),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Please Enter a Password of at least 6 characters';
                    }
                    return null; // Return null if validation passes
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
                        if (login) {
                          final userCredential = await AuthServices.signinUser(
                              email, password, context);
                          if (userCredential != null) {
                          
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => const ContributorDashboard()));
                          }
                        } else {
                          final userCredential = await AuthServices.signupUser(
                              email, password, restaurantName, context);
                          if (userCredential != null) {
                            
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => const ContributorDashboard()));
                          }
                        }
                      }
                    },
                    child: Text(login ? 'Login' : 'Signup'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  },
                  child: Text(
                    login
                        ? "Don't have an account? Signup"
                        : "Already have an account? Login",
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
