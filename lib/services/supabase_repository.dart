import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:ecosteps/data/dtos/eco_provider_dto.dart';
import 'package:ecosteps/data/dtos/sustainable_goal_dto.dart';
import 'package:ecosteps/data/mappers/eco_provider_mapper.dart';
import 'package:ecosteps/domain/entities/eco_provider.dart';
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';

class SupabaseRepository implements ISustainableGoalRemoteDatasource {
  final SupabaseClient _supabase;

  static const String _providerTable = 'providers';
  static const String _goalTable = 'sustainable_goals';

  SupabaseRepository() : _supabase = Supabase.instance.client;

  // --- Lógica de EcoProvider (Existente) ---
  Future<List<EcoProvider>> getProviders({DateTime? since}) async {
    try {
      dynamic query = _supabase.from(_providerTable).select();
      if (since != null) {
        query = query.gte('updated_at', since.toIso8601String());
      } else {
        query = query.order('updated_at', ascending: false);
      }
      final response = await query;
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

  Future<bool> hasUpdatesSince(DateTime lastSync) async {
    try {
      final response = await _supabase
          .from(_providerTable)
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

  // --- LÓGICA DE SUSTAINABLE GOAL (Implementação do Contrato) ---

  @override
  Future<List<SustainableGoalDto>> getGoalsSince(DateTime? lastSync) async {
    try {
      dynamic query = _supabase.from(_goalTable).select();
      if (lastSync != null) {
        query = query.gte('updated_at', lastSync.toIso8601String());
      }
      final response = await query.order('updated_at', ascending: false);
      return (response as List).map((json) {
        return SustainableGoalDto.fromMap(Map<String, dynamic>.from(json));
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar metas: $e');
      }
      throw Exception('Falha ao carregar metas: $e');
    }
  }

  @override
  Future<SustainableGoalDto> saveGoal(SustainableGoalDto dto) async {
    try {
      final response = await _supabase
          .from(_goalTable)
          .upsert(dto.toMap()) // Upsert cuida de 'criar' e 'atualizar'
          .select()
          .single();
      return SustainableGoalDto.fromMap(Map<String, dynamic>.from(response));
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao salvar meta: $e');
      }
      throw Exception('Falha ao salvar meta: $e');
    }
  }

  @override
  Future<void> deleteGoal(int id) async {
    try {
      await _supabase.from(_goalTable).delete().eq('id', id);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao deletar meta: $e');
      }
      throw Exception('Falha ao deletar meta: $e');
    }
  }
}
