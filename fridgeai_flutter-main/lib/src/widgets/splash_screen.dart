import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // Optionally, wait for the Lottie animation to finish
    await Future.delayed(const Duration(seconds: 5)); // Adjust the duration according to your Lottie animation length
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MyHomePage()), // Replace YourNextScreen with your main screen widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/lottie_animations/splash.json'),
      ),
    );
  }
}
