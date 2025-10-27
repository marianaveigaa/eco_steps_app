import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // ADICIONAR este import
import '../models/provider.dart';

class LocalCacheService {
  static final LocalCacheService _instance = LocalCacheService._internal();
  factory LocalCacheService() => _instance;
  LocalCacheService._internal();

  static const String _providersKey = 'cached_providers';
  static const String _lastSyncKey = 'last_sync_timestamp';

  // Salvar providers no cache
  Future<void> cacheProviders(List<EcoProvider> providers) async {
    final prefs = await SharedPreferences.getInstance();

    final providersJson =
        providers.map((provider) => provider.toJson()).toList();
    await prefs.setString(_providersKey, json.encode(providersJson));
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  // Recuperar providers do cache
  Future<List<EcoProvider>> getCachedProviders() async {
    final prefs = await SharedPreferences.getInstance();
    final providersJson = prefs.getString(_providersKey);

    if (providersJson == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(providersJson);
      return jsonList.map((json) => EcoProvider.fromJson(json)).toList();
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
}
