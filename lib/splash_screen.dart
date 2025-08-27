import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:todo_app/routes/app_routes.dart';
import 'services/firebase_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadSavedImage();
    Timer(const Duration(seconds: 2), () {
      FirebaseServices.isUserSignedIn()
          ? Navigator.of(context).pushReplacementNamed(AppRoutes.tasksScreen)
          : Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'TaskMate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Load saved image path from SharedPreferences
  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString('profile_image');
    if (savedPath == null) {
      return;
    }
  }
}
