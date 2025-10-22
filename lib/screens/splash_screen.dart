import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';
import '../services/prefs_service.dart';

class SplashScreen extends StatefulWidget {
  // Certifique-se de que é uma classe
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideRoute();
  }

  void _decideRoute() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula splash
    if (PrefsService.isPolicyAccepted('v1')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/icon.png',
                height: 150, width: 150), // Se existir
            const SizedBox(height: 20),
            Text('EcoSteps', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
