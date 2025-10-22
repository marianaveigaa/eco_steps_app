import 'package:flutter/material.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/dots_indicator.dart';
import 'policy_viewer_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Bem-vindo ao EcoSteps',
      description: 'Transforme pequenas ações em grandes impactos.',
      showSkip: true,
      icon: Icons.eco,
    ),
    const OnboardingPage(
      title: 'Como Funciona',
      description:
          'Escolha metas, registre seu progresso e veja seu impacto crescer.',
      showSkip: true,
      icon: Icons.trending_up,
    ),
    const OnboardingPage(
      title: 'Privacidade Primeiro',
      description:
          'Nós medimos seu avanço com base nas informações que você escolhe registrar. Nunca acessamos dados sensíveis.',
      showSkip: false,
      icon: Icons.privacy_tip,
    ),
  ];

  void _onPageChanged(int page) {
    if (mounted) {
      setState(() => _currentPage = page);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToPolicyViewer();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() => _goToPolicyViewer();

  void _goToPolicyViewer() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PolicyViewerScreen()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: _pages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (_currentPage < _pages.length - 1)
                  DotsIndicator(
                    count: _pages.length,
                    current: _currentPage,
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      ElevatedButton(
                        onPressed: _previousPage,
                        child: const Text('Voltar'),
                      ),
                    if (_pages[_currentPage].showSkip)
                      TextButton(
                        onPressed: _skip,
                        child: const Text('Pular'),
                      ),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(_currentPage == _pages.length - 1
                          ? 'Entendi'
                          : 'Avançar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
