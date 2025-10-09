// lib/presentation/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ecosteps/presentation/widgets/onboarding_page_widget.dart';

// 1. Convertemos para StatefulWidget para controlar o estado da página
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    // Adicionamos um "ouvinte" para saber quando a página muda
    _pageController.addListener(() {
      setState(() {
        // Se o índice da página for 2 (a terceira página), é a última.
        _isLastPage = _pageController.page == 2;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: const [
                  OnboardingPageWidget(
                    imagePath: 'assets/images/logo_ecosteps.png',
                    title: 'Bem-vindo ao EcoSteps!',
                    description:
                        'Transforme pequenas ações em grandes impactos para o planeta.',
                  ),
                  OnboardingPageWidget(
                    imagePath: 'assets/images/logo_pessoa_regando.png',
                    title: 'Crie Metas Sustentáveis',
                    description:
                        'Monitore sua redução de água, energia e lixo de forma simples.',
                  ),
                  OnboardingPageWidget(
                    imagePath: 'assets/images/privacidade.png',
                    title: 'Sua Privacidade Primeiro',
                    description:
                        'Medimos seu progresso sem coletar dados sensíveis. Você está no controle.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 2. Lógica para trocar o botão
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      if (_isLastPage) {
                        // Se for a última página, navega para o consentimento
                        context.go('/consent');
                      } else {
                        // Senão, avança para a próxima página
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    // 3. O texto do botão agora é dinâmico
                    child: Text(_isLastPage ? 'Concluir' : 'Avançar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
