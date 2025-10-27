class EcoProvider {
  final int id;
  final String name;
  final String? imageUrl;
  final String? brandColorHex;
  final double rating;
  final double? distanceKm;
  final Map<String, dynamic>? metadata;
  final DateTime updatedAt;

  EcoProvider({
    required this.id,
    required this.name,
    this.imageUrl,
    this.brandColorHex,
    required this.rating,
    this.distanceKm,
    this.metadata,
    required this.updatedAt,
  });

  // Converter de Map para EcoProvider
  factory EcoProvider.fromJson(Map<String, dynamic> json) {
    return EcoProvider(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      brandColorHex: json['brand_color_hex'] as String?,
      rating: (json['rating'] as num).toDouble(),
      distanceKm: json['distance_km'] != null
          ? (json['distance_km'] as num).toDouble()
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Converter para Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'brand_color_hex': brandColorHex,
      'rating': rating,
      'distance_km': distanceKm,
      'metadata': metadata,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
