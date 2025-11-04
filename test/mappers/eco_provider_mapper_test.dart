import 'package:flutter_test/flutter_test.dart';
import 'package:ecosteps/data/mappers/eco_provider_mapper.dart';
import 'package:ecosteps/data/dtos/eco_provider_dto.dart';

void main() {
  test('EcoProviderMapper converts DTO to Entity correctly', () {
    // Arrange
    final dto = EcoProviderDto(
      id: 1,
      name: 'Test Provider',
      imageUrl: 'https://example.com/image.jpg',
      brandColorHex: '#22AA88',
      rating: 4.5,
      distanceKm: 2.3,
      metadata: {
        'tags': ['organic', 'local'],
        'featured': true,
      },
      updatedAt: '2023-10-22T10:00:00Z',
    );

    final entity = EcoProviderMapper.toEntity(dto);

    expect(entity.id, 1);
    expect(entity.name, 'Test Provider');
    expect(entity.imageUrl, 'https://example.com/image.jpg');
    expect(entity.rating, 4.5);
    expect(entity.tags, ['organic', 'local']);
    expect(entity.featured, true);
  });
}
