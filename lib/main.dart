import 'package:cak_rawit/presentations/pages/home_screen.dart';
import 'package:cak_rawit/presentations/pages/onboarding_screen.dart';
import 'package:cak_rawit/presentations/pages/splash_screen.dart';
import 'package:cak_rawit/router/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chili Quality',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        AppRouter.dashboardScreen: (context) => HomeScreen(),
      },
    );
  }
}
