// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:lip_reading/core/routing/routes.dart';
import 'package:lip_reading/features/home_page/home_page_screen.dart';
import 'package:lip_reading/features/onboarding/onboarding_screen.dart';
import 'package:lip_reading/features/sign_up/ui/sign_up_screen.dart';

import '../../features/login/ui/login_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnBoardingScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case Routes.signupScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case Routes.homepageScreen:
        return MaterialPageRoute(
          builder: (_) => const HomePageScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
