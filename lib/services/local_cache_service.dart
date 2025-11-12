import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ecosteps/data/dtos/eco_provider_dto.dart';
import 'package:ecosteps/data/dtos/sustainable_goal_dto.dart';
import 'package:ecosteps/data/mappers/eco_provider_mapper.dart';
import 'package:ecosteps/domain/entities/eco_provider.dart';
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';

class LocalCacheService implements ISustainableGoalLocalDatasource {
  static final LocalCacheService _instance = LocalCacheService._internal();
  factory LocalCacheService() => _instance;
  LocalCacheService._internal();

  static const String _providersKey = 'cached_providers';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _goalsKey = 'cached_goals_v1';
  static const String _goalsLastSyncKey = 'goals_last_sync_v1';

  // --- Lógica de EcoProvider (Existente) ---
  Future<void> cacheProviders(List<EcoProvider> providers) async {
    final prefs = await SharedPreferences.getInstance();
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

  Future<List<EcoProvider>> getCachedProviders() async {
    final prefs = await SharedPreferences.getInstance();
    final providersJson = prefs.getString(_providersKey);
    if (providersJson == null) return [];
    try {
      final List<dynamic> jsonList = json.decode(providersJson);
      return jsonList.map((jsonMap) {
        final dto = EcoProviderDto.fromMap(Map<String, dynamic>.from(jsonMap));
        return EcoProviderMapper.toEntity(dto);
      }).toList();
    } catch (e) {
      debugPrint('Erro ao recuperar cache: $e');
      return [];
    }
  }

  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString(_lastSyncKey);
    return lastSyncString != null ? DateTime.parse(lastSyncString) : null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_providersKey);
    await prefs.remove(_lastSyncKey);
    await clearGoals();
  }

  @override
  Future<void> cacheGoals(List<SustainableGoalDto> dtos) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<int, Map<String, dynamic>> currentGoals = {};
    final raw = prefs.getString(_goalsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        for (final e in list) {
          final m = Map<String, dynamic>.from(e as Map);
          currentGoals[m['id'] as int] = m;
        }
      } catch (e) {
        debugPrint('Cache de metas corrompido, recriando... $e');
      }
    }
    for (final dto in dtos) {
      currentGoals[dto.id] = dto.toMap();
    }
    final merged = currentGoals.values.toList();
    await prefs.setString(_goalsKey, jsonEncode(merged));
  }

  @override
  Future<List<SustainableGoalDto>> getCachedGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_goalsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) =>
              SustainableGoalDto.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      debugPrint('Erro ao ler cache de metas: $e');
      return [];
    }
  }

  @override
  Future<void> clearGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_goalsKey);
    await prefs.remove(_goalsLastSyncKey);
  }

  @override
  Future<DateTime?> getLastGoalSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString(_goalsLastSyncKey);
    return lastSyncString != null ? DateTime.parse(lastSyncString) : null;
  }

  @override
  Future<void> saveLastGoalSync(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalsLastSyncKey, time.toIso8601String());
  }

  void debugPrint(String s) {}
}
