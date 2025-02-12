import 'package:flutter/material.dart';
import 'package:main_project/screens/signin_screen.dart';
import 'package:main_project/screens/signup_screen.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/image4.png', // Replace with your image path
              fit: BoxFit.cover,
              
            ),
          ),
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 80.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome Back!\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        TextSpan(
                          text:
                            "Let's Get Started!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              // height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100.0),
                  topRight: Radius.circular(100.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
                  children: [
                    // Sign In Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SigninScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
                        minimumSize: Size(200, 20), // Adjust size as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 43, 11, 11),
                        minimumSize: Size(200, 20), // Adjust size as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.app_registration, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}