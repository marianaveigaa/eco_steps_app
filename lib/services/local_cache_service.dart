import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/dtos/eco_provider_dto.dart';
import '../data/mappers/eco_provider_mapper.dart';
import '../domain/entities/eco_provider.dart';

class LocalCacheService {
  static final LocalCacheService _instance = LocalCacheService._internal();
  factory LocalCacheService() => _instance;
  LocalCacheService._internal();

  static const String _providersKey = 'cached_providers';
  static const String _lastSyncKey = 'last_sync_timestamp';

  // Salvar providers no cache (usando DTOs)
  Future<void> cacheProviders(List<EcoProvider> providers) async {
    final prefs = await SharedPreferences.getInstance();

    // Converter entidades para DTOs
    final providerDtos = providers.map((provider) {
      return {
        'id': provider.id,
        'name': provider.name,
        'image_url': provider.imageUrl,
        'brand_color_hex': provider.brandColorHex,
        'rating': provider.rating,
        'distance_km': provider.distanceKm,
        'metadata': {
          'tags': provider.tags,
          'featured': provider.featured,
        },
        'updated_at': provider.updatedAt.toIso8601String(),
      };
    }).toList();

    await prefs.setString(_providersKey, json.encode(providerDtos));
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  // Recuperar providers do cache (convertendo DTOs para Entities)
  Future<List<EcoProvider>> getCachedProviders() async {
    final prefs = await SharedPreferences.getInstance();
    final providersJson = prefs.getString(_providersKey);

    if (providersJson == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(providersJson);

      return jsonList.map((jsonMap) {
        // Criar DTO a partir do mapa
        final dto = EcoProviderDto.fromMap(Map<String, dynamic>.from(jsonMap));
        // Converter DTO para Entity usando o Mapper
        return EcoProviderMapper.toEntity(dto);
      }).toList();
    } catch (e) {
      debugPrint('Erro ao recuperar cache: $e');
      return [];
    }
  }

  // Obter última sincronização
  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString(_lastSyncKey);

    return lastSyncString != null ? DateTime.parse(lastSyncString) : null;
  }

  // Limpar cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_providersKey);
    await prefs.remove(_lastSyncKey);
  }

  void debugPrint(String s) {}
}
