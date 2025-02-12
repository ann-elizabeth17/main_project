import 'package:flutter/material.dart';
import 'package:main_project/screens/splash_screen_page.dart';
import 'package:video_player/video_player.dart';

class SplashScreen1Page extends StatefulWidget {
  const SplashScreen1Page({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen1Page> {
  late VideoPlayerController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/splashscreen.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });

    // Simulate a loading process
    _simulateLoading();
  }

  void _simulateLoading() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 40));
      setState(() {
        _progress = i / 100.0;
      });
    }

    // Navigate to the next screen after loading
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreenPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Video
          if (_controller.value.isInitialized)
            VideoPlayer(_controller)
          else
            Container(color: Colors.black),

          // Overlay and customized rounded loading bar
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2, // Move loader upwards
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded edges
              child: SizedBox(
                height: 10, // Increased thickness
                child: LinearProgressIndicator(
                  value: _progress,
                  color: const Color.fromARGB(255, 43, 11, 11),
                  backgroundColor: Colors.grey.withOpacity(0.5),
                  minHeight: 10, // Thickness of the loader
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
