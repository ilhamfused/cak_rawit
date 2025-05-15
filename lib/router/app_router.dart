import 'package:cak_rawit/presentations/pages/home_screen.dart';
import 'package:cak_rawit/presentations/pages/onboarding_screen.dart';
import 'package:cak_rawit/presentations/pages/splash_screen.dart';
import 'package:flutter/material.dart';

// Daftar rute
final Map<String, WidgetBuilder> routes = {
  AppRouter.splash: (context) => const SplashScreen(),
  AppRouter.onboardingScreen: (context) => const OnboardingScreen(),
  AppRouter.dashboardScreen: (context) => HomeScreen(),
  // Tambahkan rute lainnya di sini
};

class AppRouter {
  static const String splash = "/splash_screen";
  static const String onboardingScreen = "/OnboardingScreen";
  static const String dashboardScreen = "/DashboardScreen";
}
// Tambahkan rute lainnya di sini

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: AppRouter.splash,
      routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case AppRouter.splash:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case AppRouter.onboardingScreen:
            return MaterialPageRoute(builder: (_) => const OnboardingScreen());
          case AppRouter.dashboardScreen:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          // Tambahkan rute lainnya di sini
          default:
            return MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
            );
        }
      },
    );
  }
}
