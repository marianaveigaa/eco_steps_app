import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/provider.dart';

class SupabaseRepository {
  final SupabaseClient _supabase;

  SupabaseRepository() : _supabase = Supabase.instance.client;

  // Buscar todos os providers (com sincronização incremental)
  Future<List<EcoProvider>> getProviders({DateTime? since}) async {
    try {
      // Método CORRETO para filtrar datas
      if (since != null) {
        final response = await _supabase
            .from('providers')
            .select()
            .gte('updated_at', since.toIso8601String())
            .order('updated_at', ascending: false);

        return (response as List)
            .map((json) => EcoProvider.fromJson(json))
            .toList();
      } else {
        // Sem filtro de data
        final response = await _supabase
            .from('providers')
            .select()
            .order('updated_at', ascending: false);

        return (response as List)
            .map((json) => EcoProvider.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Erro ao buscar providers: $e');
      throw Exception('Falha ao carregar dados');
    }
  }

  // Buscar provider por ID
  Future<EcoProvider?> getProviderById(int id) async {
    try {
      final response =
          await _supabase.from('providers').select().eq('id', id).single();

      return EcoProvider.fromJson(response);
    } catch (e) {
      debugPrint('Erro ao buscar provider $id: $e');
      return null;
    }
  }

  // Verificar se há atualizações
  Future<bool> hasUpdatesSince(DateTime lastSync) async {
    try {
      final response = await _supabase
          .from('providers')
          .select()
          .gte('updated_at', lastSync.toIso8601String())
          .limit(1);

      return response.isNotEmpty;
    } catch (e) {
      debugPrint('Erro ao verificar atualizações: $e');
      return true; // Assume que há atualizações em caso de erro
    }
  }
}
