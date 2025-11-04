import '../dtos/eco_provider_dto.dart';
import '../../domain/entities/eco_provider.dart';

class EcoProviderMapper {
  static EcoProvider toEntity(EcoProviderDto dto) {
    final metadata = dto.metadata ?? {};
    final tags =
        (metadata['tags'] as List?)?.whereType<String>().toList() ?? [];
    final featured = metadata['featured'] == true;

    return EcoProvider(
      id: dto.id,
      name: dto.name,
      imageUrl: dto.imageUrl,
      brandColorHex: dto.brandColorHex,
      rating: dto.rating.clamp(0.0, 5.0),
      distanceKm: dto.distanceKm,
      tags: tags,
      featured: featured,
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }
}
