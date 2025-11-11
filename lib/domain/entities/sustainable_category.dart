import 'package:flutter/material.dart';

// Este enum representa as categorias de metas, como visto no PDF
enum SustainableCategory {
  lixo,
  agua,
  energia,
  transporte,
}

// Extensão para dar ao enum propriedades (ícone e descrição)
extension SustainableCategoryDetails on SustainableCategory {
  String get description {
    switch (this) {
      case SustainableCategory.lixo:
        return 'Redução de Lixo';
      case SustainableCategory.agua:
        return 'Economia de Água';
      case SustainableCategory.energia:
        return 'Consumo de Energia';
      case SustainableCategory.transporte:
        return 'Transporte Verde';
    }
  }

  IconData get icon {
    switch (this) {
      case SustainableCategory.lixo:
        return Icons.delete_outline;
      case SustainableCategory.agua:
        return Icons.water_drop_outlined;
      case SustainableCategory.energia:
        return Icons.lightbulb_outline;
      case SustainableCategory.transporte:
        return Icons.directions_bus_filled_outlined;
    }
  }
}
