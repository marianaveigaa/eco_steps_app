import 'package:flutter/material.dart';
// --- IMPORTAÇÕES CORRIGIDAS ---
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';
import 'package:ecosteps/data/repositories/sustainable_goal_repository.dart';
import 'package:ecosteps/services/local_cache_service.dart';
import 'package:ecosteps/services/supabase_repository.dart';
import 'package:ecosteps/widgets/sustainable_goal_form_dialog.dart';
import 'package:ecosteps/domain/entities/sustainable_category.dart';
// --- FIM DAS IMPORTAÇÕES ---

class SustainableGoalListPage extends StatefulWidget {
  const SustainableGoalListPage({super.key});

  @override
  State<SustainableGoalListPage> createState() =>
      _SustainableGoalListPageState();
}

class _SustainableGoalListPageState extends State<SustainableGoalListPage>
    with SingleTickerProviderStateMixin {
  bool _showTip = true;

  late final AnimationController _fabController;
  late final Animation<double> _fabScale;

  late final ISustainableGoalRepository _repository;
  Future<List<SustainableGoal>>? _goalsFuture;

  @override
  void initState() {
    super.initState();

    _repository = SustainableGoalRepository(
      remote: SupabaseRepository(),
      local: LocalCacheService(),
    );
    _loadGoals();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fabScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticInOut),
    );
  }

  void _loadGoals({bool showLoading = false}) {
    if (!showLoading) {
      setState(() {
        _goalsFuture = _repository.getGoals();
      });
      return;
    }

    setState(() {
      _goalsFuture = null;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _goalsFuture = _repository.getGoals();
        });
      }
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _openGoalForm([SustainableGoal? initial]) async {
    final result = await showSustainableGoalFormDialog(
      context,
      initial: initial,
      repository: _repository,
    );

    if (result != null) {
      _loadGoals(showLoading: true);
    }
  }

  void _deleteGoal(SustainableGoal goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir a meta "${goal.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _repository.deleteGoal(goal);
        _loadGoals(showLoading: true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meta excluída com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Metas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadGoals(showLoading: true),
            tooltip: 'Atualizar',
          )
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildBody(context),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFab(BuildContext context) {
    return ScaleTransition(
      scale: _fabScale,
      child: FloatingActionButton(
        onPressed: _openGoalForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_goalsFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<SustainableGoal>>(
      future: _goalsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar metas: ${snapshot.error}'),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty && _showTip) {
          _fabController.repeat(reverse: true);
        } else {
          _fabController.stop();
          _fabController.reset();
        }

        if (items.isEmpty) {
          return Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.track_changes,
                      size: 72,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(100),
                    ),
                    const SizedBox(height: 16),
                    const Text('Nenhuma meta cadastrada ainda.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    const Text('Use o botão + para criar sua primeira meta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              if (_showTip) _buildTipBubble(context),
              if (_showTip) _buildOptOutButton(context),
            ],
          );
        }

        // Lista de Metas
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final goal = items[index];
            final category = SustainableCategory.values.firstWhere(
              (e) => e.name == goal.category,
              orElse: () => SustainableCategory.lixo,
            );

            return ListTile(
              leading: CircleAvatar(
                child: Icon(category.icon),
              ),
              title: Text(goal.title),
              subtitle: Text(
                  '${goal.progressText} (${goal.currentValue} / ${goal.targetValue} ${goal.unit})'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (goal.completed)
                    Icon(Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteGoal(goal),
                  ),
                ],
              ),
              onTap: () => _openGoalForm(goal), // Abre em modo de edição
            );
          },
        );
      },
    );
  }

  Widget _buildTipBubble(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: MediaQuery.of(context).padding.bottom + 85,
      child: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          final v = _fabController.value;
          return Transform.translate(
            offset: Offset(0, 10 * (1 - v)),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
            ],
          ),
          child: Text(
            'Toque aqui para adicionar uma meta',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildOptOutButton(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: MediaQuery.of(context).padding.bottom + 12,
      child: TextButton(
        onPressed: () => setState(() {
          _showTip = false;
          _fabController.stop();
          _fabController.reset();
        }),
        child: const Text('Não exibir dica'),
      ),
    );
  }
}
