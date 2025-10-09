import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecosteps/core/services/prefs_service.dart';
import 'package:ecosteps/core/services/service_locator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    // Aguarda um momento para exibir a logo
    await Future.delayed(const Duration(seconds: 2));

    final prefsService = getIt<PrefsService>();
    final isPolicyAccepted = prefsService.getAcceptedPoliciesVersion() != null;

    // Evita erro de "não usar BuildContext em métodos async"
    if (mounted) {
      if (isPolicyAccepted) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logo_ecosteps.png'),
              width: 120,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
