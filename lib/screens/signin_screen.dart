import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/screens/admin/admin_dashboard_page.dart';
import 'package:main_project/screens/forget_password_screen.dart';
import 'package:main_project/screens/home_screen.dart';
import 'package:main_project/screens/signup_screen.dart';
import 'package:main_project/theme/theme.dart';
import 'package:main_project/widgets/custom_scaffold.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Default admin credentials
  final String adminEmail = 'annelizabeth174@gmail.com'; // Replace with the actual admin email
  final String adminPassword = 'annelizabeth3@jesus'; // Replace with the actual admin password

  Future<void> _signIn() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Check if the entered credentials match the default admin credentials
      if (email == adminEmail && password == adminPassword) {
        // If credentials match, navigate to the Admin Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminDashboardPage(),
          ),
        );
        return;
      }

      // Sign in using Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Get the user ID
        final String userId = userCredential.user!.uid;

        // Fetch the user's role from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('registrationUser')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          final role = userDoc['role'];

          // Check the user's role and navigate accordingly
          if (role == 'User') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userId: userId), // Pass the userId here
              ),
            );
          } else {
            _showErrorDialog('You are not authorized to log in');
          }
        } else {
          _showErrorDialog('User data not found.');
        }
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }

  void _showUserNotRegisteredDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Not Registered'),
          content: const Text('You are not a registered user. Please sign up to login to your account!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          }
                          RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please Enter a valid Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          if (value.length < 8) {
                            return 'Password should be at least 8 characters long';
                          }
                          RegExp passwordRegExp = RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
                          if (!passwordRegExp.hasMatch(value)) {
                            return 'Password should contain at least one number and one special character';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: lightColorScheme.primary,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPasswordScreen()
                                ),
                              );
                            },
                            child: Text(
                              'Forget password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignInKey.currentState?.validate() ?? false) {
                              _signIn();
                            }
                          },
                          child: const Text('Sign in'),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.black45),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (e) => const SignupScreen()),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
