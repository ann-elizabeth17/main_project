import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/theme/theme.dart';
import 'package:main_project/widgets/custom_scaffold.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    final email = _emailController.text.trim();
    try {
      // Check Firestore for email existence
      final querySnapshot = await FirebaseFirestore.instance
          .collection('registrationUser')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If email exists, send password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Password Reset Link sent! Check your email."),
            );
          },
        );
      } else {
        // Email does not exist in Firestore
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Email doesn't exist in our records."),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message ?? "An unexpected error occurred."),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("An error occurred: $e"),
          );
        },
      );
    }
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Verify Your Email',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Enter your Email and we will send you a password reset link',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          }
                          RegExp emailRegExp =
                              RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$');
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
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: passwordReset,
                          child: const Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
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
