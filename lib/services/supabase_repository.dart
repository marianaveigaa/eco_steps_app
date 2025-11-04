import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../data/dtos/eco_provider_dto.dart';
import '../data/mappers/eco_provider_mapper.dart';
import '../domain/entities/eco_provider.dart';

class SupabaseRepository {
  final SupabaseClient _supabase;

  SupabaseRepository() : _supabase = Supabase.instance.client;

  // Buscar todos os providers (com sincronização incremental)
  Future<List<EcoProvider>> getProviders({DateTime? since}) async {
    try {
      dynamic query;

      if (since != null) {
        // Com filtro de data - usar tipo dinâmico para evitar conflito
        query = _supabase
            .from('providers')
            .select()
            .gte('updated_at', since.toIso8601String())
            .order('updated_at', ascending: false);
      } else {
        // Sem filtro
        query = _supabase
            .from('providers')
            .select()
            .order('updated_at', ascending: false);
      }

      final response = await query;

      // Converter para lista de EcoProvider
      return (response as List).map((json) {
        final dto = EcoProviderDto.fromMap(Map<String, dynamic>.from(json));
        return EcoProviderMapper.toEntity(dto);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar providers: $e');
      }
      throw Exception('Falha ao carregar dados: $e');
    }
  }

  // Buscar provider por ID
  Future<EcoProvider?> getProviderById(int id) async {
    try {
      final response =
          await _supabase.from('providers').select().eq('id', id).single();

      final dto = EcoProviderDto.fromMap(Map<String, dynamic>.from(response));
      return EcoProviderMapper.toEntity(dto);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar provider $id: $e');
      }
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
      if (kDebugMode) {
        print('Erro ao verificar atualizações: $e');
      }
      return true;
    }
  }
}
