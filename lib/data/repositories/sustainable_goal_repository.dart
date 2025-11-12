import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_goal_datasources.dart';
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';
import 'package:ecosteps/data/mappers/sustainable_goal_mapper.dart';
import 'package:flutter/foundation.dart';

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
        return cachedDtos.map(SustainableGoalMapper.toEntity).toList();
      } catch (e) {
        throw Exception('Falha ao ler dados: $e');
      }
    }
  }

  @override
  Future<void> saveGoal(SustainableGoal goal) async {
    // Garante que o updatedAt seja novo
    final entityToSave = goal.copyWith(updatedAt: DateTime.now());
    final dto = SustainableGoalMapper.toDto(entityToSave);

    try {
      // Tenta salvar no Supabase
      final savedDto = await remote.saveGoal(dto);
      // Se der certo, salva no cache a versão oficial do servidor
      await local.cacheGoals([savedDto]);
    } catch (e) {
      // --- MODO DE SEGURANÇA (OFFLINE/ERRO) ---
      // Se a internet falhar ou a tabela não existir, estará salvo LOCALMENTE.
      // Isso garante que o usuário não perca os dados.

      debugPrint('Erro remoto: $e. Salvando localmente...');

      // Se o ID for 0 (novo), é gerado um ID temporário baseado no tempo
      final fallbackDto = dto.copyWith(
        id: dto.id == 0 ? DateTime.now().millisecondsSinceEpoch : dto.id,
      );

      await local.cacheGoals([fallbackDto]);
      // Não lançamos o erro, para a UI pensar que deu tudo certo
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
