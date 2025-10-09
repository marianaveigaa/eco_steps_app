import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // O estilo é definido uma única vez, aqui!
      style: isFullWidth
          ? ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50))
          : null,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
