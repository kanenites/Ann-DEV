import 'package:flutter/material.dart';
import '../functions/auth_functions.dart';
import 'admin_dashboard.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String restrauntName = '';
  bool isLogin = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(isLogin ? 'Admin Login' : 'Admin Signup'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLogin)
                  TextFormField(
                    key: const ValueKey('restrauntName'),
                    decoration: const InputDecoration(
                      hintText: 'Enter Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Name';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        restrauntName = value!;
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
                      return 'Please Enter a valid Email';
                    } else {
                      return null;
                    }
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
                      return 'Please Enter a Password of at least 6 characters';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value!;
                    });
                  },
                ),
                SizedBox(height: 30),
                Container(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (isLogin) {
                          final userCredential = await AdminAuthServices.signinAdmin(
                              email, password, context);
                          if (userCredential != null) {
                            // Navigate to admin dashboard
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
                          }
                        } else {
                          final userCredential = await AdminAuthServices.signupAdmin(
                              email, password, restrauntName, context);
                          if (userCredential != null) {
                            // Navigate to admin dashboard
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
                          }
                        }
                      }
                    },
                    child: Text(isLogin ? 'Login' : 'Signup'),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
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
