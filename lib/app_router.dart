// lib/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:ecosteps/presentation/screens/splash/splash_screen.dart';
import 'package:ecosteps/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:ecosteps/presentation/screens/consent/consent_screen.dart';
import 'package:ecosteps/presentation/screens/consent/policy_viewer_screen.dart';
import 'package:ecosteps/presentation/screens/home/home_screen.dart';
import 'package:ecosteps/presentation/screens/settings/settings_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen()),
    GoRoute(
        path: '/consent', builder: (context, state) => const ConsentScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/settings', builder: (context, state) => const SettingsScreen()),

    // VERSÃO FINAL E SEGURA DO VISUALIZADOR DE POLÍTICAS
    GoRoute(
        path: '/policy-viewer',
        builder: (context, state) {
          // Usa um 'cast' seguro. Se 'extra' não for uma String, usa um valor padrão.
          final markdownFile =
              state.extra as String? ?? 'assets/markdown/error.md';
          return PolicyViewerScreen(markdownFile: markdownFile);
        }),
  ],
);
