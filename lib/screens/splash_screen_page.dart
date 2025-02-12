import 'package:flutter/material.dart';
import 'package:main_project/screens/splash_screen2_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return SplashPage(
            imagePath: _getImagePath(index),
            title: _getTitle(index),
            description: _getDescription(index),
            buttonText: index == 2 ? 'Get Started' : 'Next',
            onTap: () {
              if (index < 2) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeInOutQuint,
                );
              } else {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => SplashScreen2Page())
                );
              }
            },
          );
        },
      ),
    );
  }

  String _getImagePath(int index) {
    switch (index) {
      case 0:
        return 'assets/images/splashscreen.jpg';
      case 1:
        return 'assets/images/splashscreen1.jpg';
      case 2:
        return 'assets/images/splashscreen2.jpg';
      default:
        return '';
    }
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Delicious Healthy Recipes';
      case 1:
        return 'Track Your Nutrition';
      case 2:
        return 'Personalized Calorie Targets';
      default:
        return '';
    }
  }

  String _getDescription(int index) {
    switch (index) {
      case 0:
        return 'Discover a world of healthy, mouth-watering recipes tailored for your needs.';
      case 1:
        return 'Get precise nutritional insights to ensure every meal you eat helps you achieve your goals.';
      case 2:
        return 'Set your weight goal and let us handle the rest. Achieve your dream body effortlessly.';
      default:
        return '';
    }
  }
}

class SplashPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  SplashPage({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
   return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: DropDownImage(
            imagePath: imagePath,
          ),
        ),
        const SizedBox(height: 20),
        SlidingTexts(
          title: title,
          description: description,
        ),
       // const Spacer(), // Adds space to push the button upwards
       const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 43, 11, 11),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 30), // Adjust spacing below the button
      ],
    ),
  );

  }
}

class DropDownImage extends StatelessWidget {
  final String imagePath;

  DropDownImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)),
      duration: Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(0, offset.dy * MediaQuery.of(context).size.height),
          child: ClipPath(
            clipper: BottomWaveClipper(),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
          ),
        );
      },
    );
  }
}

class SlidingTexts extends StatelessWidget {
  final String title;
  final String description;

  SlidingTexts({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder(
          tween: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)),
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: Offset(offset.dx * MediaQuery.of(context).size.width, 0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 10),
        TweenAnimationBuilder(
          tween: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)),
          duration: Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: Offset(offset.dx * MediaQuery.of(context).size.width, 0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start at bottom-left
    path.quadraticBezierTo(
      size.width / 2, // Control point (x)
      size.height,    // Control point (y)
      size.width,     // End point (x)
      size.height - 50, // End point (y)
    );
    path.lineTo(size.width, 0); // Line to top-right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
