import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppDotsIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const AppDotsIndicator({
    super.key,
    required this.controller,
    required this.count,
    required WormEffect effect,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      // Todas as configurações de estilo ficam aqui, em um só lugar.
      effect: WormEffect(
        dotHeight: 12,
        dotWidth: 12,
        activeDotColor: Theme.of(context).colorScheme.primary,
        dotColor: Colors.grey.shade300,
      ),
    );
  }
}
