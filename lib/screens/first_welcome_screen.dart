import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_project/screens/second_welcome_screen.dart';

class FirstWelcomeScreen extends StatelessWidget {
  const FirstWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 100, bottom: 40),
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("assets/images/image6.png"),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 50.0),
              child: Text("Zaika-e-North Tales", style: GoogleFonts.pacifico(
                fontSize: 50,
                color: Colors.white,
              ),),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Text(
                    'Indulge in the Flavors of the North!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                InkWell(
                  splashColor: Colors.black,
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => SecondWelcomeScreen(),
                      )
                    );
                  },
                  child: Ink(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 35,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 213, 196),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 168, 77, 2),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}