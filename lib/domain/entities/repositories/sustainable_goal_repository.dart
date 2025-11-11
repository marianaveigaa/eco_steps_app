// --- IMPORTAÇÕES CORRIGIDAS ---
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';
import 'package:ecosteps/data/mappers/sustainable_goal_mapper.dart';
// --- FIM DAS IMPORTAÇÕES ---

class SustainableGoalRepository implements ISustainableGoalRepository {
  final ISustainableGoalRemoteDatasource remote;
  final ISustainableGoalLocalDatasource local;

  SustainableGoalRepository({
    required this.remote,
    required this.local,
  });

  @override
  Future<List<SustainableGoal>> getGoals() async {
    try {
      final lastSync = await local.getLastGoalSync();
      final remoteDtos = await remote.getGoalsSince(lastSync);

      if (remoteDtos.isNotEmpty) {
        await local.cacheGoals(remoteDtos);
        await local.saveLastGoalSync(DateTime.now());
      }

      final allCachedDtos = await local.getCachedGoals();
      return allCachedDtos.map(SustainableGoalMapper.toEntity).toList();
    } catch (e) {
      try {
        final cachedDtos = await local.getCachedGoals();
        if (cachedDtos.isNotEmpty) {
          return cachedDtos.map(SustainableGoalMapper.toEntity).toList();
        } else {
          throw Exception('Falha na rede e sem cache local.');
        }
      } catch (e) {
        throw Exception('Falha ao ler dados: $e');
      }
    }
  }

  @override
  Future<void> saveGoal(SustainableGoal goal) {
    // Garante que o updatedAt seja novo
    final entityToSave = goal.copyWith(updatedAt: DateTime.now());
    final dto = SustainableGoalMapper.toDto(entityToSave);

    try {
      // Usamos .then() para garantir que o cache seja atualizado *depois* do remoto
      return remote.saveGoal(dto).then((savedDto) {
        return local.cacheGoals([savedDto]);
      });
    } catch (e) {
      throw Exception('Falha ao salvar meta: $e');
    }
  }

  @override
  Future<void> deleteGoal(SustainableGoal goal) async {
    try {
      await remote.deleteGoal(goal.id);

      final allGoals = await local.getCachedGoals();
      allGoals.removeWhere((g) => g.id == goal.id);
      await local.clearGoals();
      await local.cacheGoals(allGoals);
    } catch (e) {
      throw Exception('Falha ao deletar meta: $e');
    }
  }
}
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';
import 'package:ecosteps/data/mappers/sustainable_goal_mapper.dart';

class SustainableGoalRepository implements ISustainableGoalRepository {
  final ISustainableGoalRemoteDatasource remote;
  final ISustainableGoalLocalDatasource local;

  SustainableGoalRepository({
    required this.remote,
    required this.local,
  });

  @override
  Future<List<SustainableGoal>> getGoals() async {
    try {
      final lastSync = await local.getLastGoalSync();
      final remoteDtos = await remote.getGoalsSince(lastSync);

      if (remoteDtos.isNotEmpty) {
        await local.cacheGoals(remoteDtos);
        await local.saveLastGoalSync(DateTime.now());
      }
      
      final allCachedDtos = await local.getCachedGoals();
      return allCachedDtos.map(SustainableGoalMapper.toEntity).toList();
    } catch (e) {
      // Se a rede falhar, tenta retornar o cache
      try {
        final cachedDtos = await local.getCachedGoals();
        if (cachedDtos.isNotEmpty) {
          return cachedDtos.map(SustainableGoalMapper.toEntity).toList();
        } else {
          throw Exception('Falha na rede e sem cache local.');
        }
      } catch (e) {
        throw Exception('Falha ao ler dados: $e');
      }
    }
  }

  @override
  Future<void> saveGoal(SustainableGoal goal) {
    final entityToSave = goal.copyWith(updatedAt: DateTime.now());
    final dto = SustainableGoalMapper.toDto(entityToSave);

    try {
      return remote.saveGoal(dto).then((savedDto) {
        return local.cacheGoals([savedDto]);
      });
    } catch (e) {
      throw Exception('Falha ao salvar meta: $e');
    }
  }

  @override
  Future<void> deleteGoal(SustainableGoal goal) async {
    try {
      await remote.deleteGoal(goal.id);
      
      final allGoals = await local.getCachedGoals();
      allGoals.removeWhere((g) => g.id == goal.id);
      await local.clearGoals(); 
      await local.cacheGoals(allGoals);
    } catch (e) {
      throw Exception('Falha ao deletar meta: $e');
    }
  }
}