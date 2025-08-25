import 'package:flutter/material.dart';
import 'package:todo_app/login_screen.dart';
import 'package:todo_app/signup_screen.dart';
import 'package:todo_app/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String loginScreen = '/login';
  static const String signupScreen = '/signup';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    signupScreen: (context) => const SignupScreen(),
  };
}
