import 'dart:async';

import 'package:cak_rawit/presentations/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _precacheImages();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return OnboardingScreen();
          },
        ),
      );
    });
  }

  Future<void> _precacheImages() async {
    // Preload all the images used in the screen
    await Future.wait([
      precacheImage(Image.asset("assets/images/logo-full.png").image, context),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo-full.png",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
