class EcoProvider {
  final int id;
  final String name;
  final String? imageUrl;
  final String? brandColorHex;
  final double rating;
  final double? distanceKm;
  final List<String> tags;
  final bool featured;
  final DateTime updatedAt;

  EcoProvider({
    required this.id,
    required this.name,
    this.imageUrl,
    this.brandColorHex,
    required this.rating,
    this.distanceKm,
    List<String>? tags,
    this.featured = false,
    required this.updatedAt,
  }) : tags = tags ?? [];

  String get subtitle =>
      '⭐ ${rating.toStringAsFixed(1)} • ${distanceKm?.toStringAsFixed(1) ?? 'N/A'} km';
}
