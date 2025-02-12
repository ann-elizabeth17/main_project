import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_project/screens/signin_screen.dart';

class SplashScreen2Page extends StatefulWidget {
  @override
  _SplashScreen2PageState createState() => _SplashScreen2PageState();
}

class _SplashScreen2PageState extends State<SplashScreen2Page>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _imageControllers;
  late AnimationController _textController;
  late Animation<Offset> _slideTextAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    // Initialize controllers for slide animations
    _imageControllers = List.generate(
      5,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
      ),
    );

    // Initialize controller for the zoom-in text
    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Slide-in animation for the "Jodhpuri Kabuli Pulao" text
    _slideTextAnimation = Tween<Offset>(
      begin: Offset(2, 0),  // Start off-screen
      end: Offset(0, 0),    // End at the desired position
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Start animations one by one for images
    for (int i = 0; i < _imageControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        _imageControllers[i].forward();
      });
    }

    // Start the text sliding animation after the 3rd image has finished
    Future.delayed(Duration(milliseconds: 2900), () {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _imageControllers) {
      controller.dispose();
    }
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full left-aligned semicircle using CustomPaint
          Positioned.fill(
            child: CustomPaint(
              painter: LeftAlignedSemicirclePainter(
                widthFactor: 1.0,
                heightFactor: 1.0,
              ),
            ),
          ),
          // Dishes images with slide-in animation
          _slideInImage('assets/images/splashimg2.png', 5, 50, _imageControllers[0]),
          _slideInImage('assets/images/splashimg1.png', 120, 120, _imageControllers[1]),
          _slideInImage('assets/images/splashimg3.png', 230, 100, _imageControllers[4], width: 200, height: 200),
          _slideInImage('assets/images/splashimg4.png', 440, 120, _imageControllers[3]),
          _slideInImage('assets/images/splashimg5.png', 530, 20, _imageControllers[2], width: 100, height: 100),
          
          // Center dish with scale animation
          Align(
            alignment: Alignment.center,
            child: ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.1)
                  .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/center_dish.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // "Today's Special" text
          Positioned(
            top: 70,
            right: 40,
            child: Text(
              "Today's\nSpecial",
              textAlign: TextAlign.right,
              style: GoogleFonts.playfairDisplay(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 43, 11, 11),
              ),
            ),
          ),
          // "Jodhpuri Kabuli Pulao" text that slides in after images finish sliding in
          Positioned(
            top: 350,
            right: 10,
            child: SlideTransition(
              position: _slideTextAnimation,
              child: Text(
                "Jodhpuri Kabuli \n Pulao",
                style: GoogleFonts.bonheurRoyale(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 43, 11, 11)
                ),
              ),
            ),
          ),
          
          // "Get Started ->" button
          Positioned(
            bottom: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              },
              child: Text(
                "Sign In to Explore Our Menu ->",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 43, 11, 11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slideInImage(String imagePath, double top, double left, AnimationController controller,
      {double width = 100, double height = 100}) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Positioned(
          top: top,
          left: Tween<double>(begin: -200, end: left).evaluate(controller), // Slide in from left
          child: child!,
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class LeftAlignedSemicirclePainter extends CustomPainter {
  final double widthFactor;
  final double heightFactor;

  LeftAlignedSemicirclePainter({
    this.widthFactor = 1.0,
    this.heightFactor = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 43, 11, 11)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromLTWH(
        -size.height / 1.5 * widthFactor,
        -(size.height * (heightFactor - 1) / 2),
        size.height * widthFactor,
        size.height * heightFactor,
      ),
      1.5 * 3.14,
      3.14,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


