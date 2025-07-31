import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/main.dart';
import 'package:final_project/core/routes/route_names.dart';
import 'package:final_project/core/widgets/custom_text.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _decideNextScreen();
  }

  Future<void> _decideNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final bool hasSeenOnboarding =
        sharedPreferences.getBool('hasSeenOnboarding') ?? false;

    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (hasSeenOnboarding) {
      if (currentUser != null) {
        Navigator.pushReplacementNamed(context, RouteNames.home);
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      }
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF514eb7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomText(
              text: 'Kutuku',
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            const CustomText(
              text: 'Any shopping just from here',
              fontSize: 18,
              color: Colors.white,
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
