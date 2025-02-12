import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_project/firebase_options.dart';
import 'package:main_project/screens/splashscreen1_page.dart';
import 'package:main_project/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zaika-e-North Tales',
      theme: lightMode,
      home: SplashScreen1Page(),
    );
  }
}

