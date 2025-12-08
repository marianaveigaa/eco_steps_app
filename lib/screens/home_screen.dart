import 'package:flutter/material.dart';
import 'package:ecosteps/services/prefs_service.dart';
import 'package:ecosteps/services/supabase_repository.dart';
import 'package:ecosteps/services/local_cache_service.dart';
import 'package:ecosteps/domain/entities/eco_provider.dart';
import 'package:ecosteps/widgets/profile_drawer.dart';
import 'package:ecosteps/screens/splash_screen.dart';
import 'package:ecosteps/screens/sustainable_goal_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseRepository _repository = SupabaseRepository();
  final LocalCacheService _cacheService = LocalCacheService();

  List<EcoProvider> _providers = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final cachedProviders = await _cacheService.getCachedProviders();
      if (cachedProviders.isNotEmpty && mounted) {
        setState(() {
          _providers = cachedProviders;
        });
      }

      final lastSync = await _cacheService.getLastSync();
      final freshProviders = await _repository.getProviders(since: lastSync);

      if (freshProviders.isNotEmpty && mounted) {
        await _cacheService.cacheProviders(freshProviders);
        setState(() {
          _providers = freshProviders;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _revokeConsent(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Revogar Consentimento'),
        content: const Text(
            'Tem certeza? Isso resetará seu progresso e levará você de volta ao onboarding.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => _confirmRevoke(context),
            child: const Text('Revogar'),
          ),
        ],
      ),
    );
  }

  void _confirmRevoke(BuildContext context) async {
    await PrefsService.revokeAcceptance();
    await _cacheService.clearCache();

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consentimento revogado. Redirecionando...'),
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false,
          );
        }
      });
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em breve!')),
    );
  }

  Widget _buildProviderCard(EcoProvider provider) {
    final distanceText =
        provider.distanceKm != null ? '${provider.distanceKm} km' : 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: provider.imageUrl != null && provider.imageUrl!.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(provider.imageUrl!),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              )
            : CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.storefront,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
        title: Text(provider.name),
        subtitle: Text('⭐ ${provider.rating} • $distanceText'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showComingSoon(context),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            const Text('Erro ao carregar dados'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_providers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 100, color: Color(0xFF16A34A)),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo ao EcoSteps!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Crie sua primeira meta sustentável da semana!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SustainableGoalListPage(),
                          ),
                        );
                      },
                      child: const Text('Criar Meta'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // AQUI FOI ADICIONADO O TÍTULO ACIMA DA LISTA
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        // +1 para o título
        itemCount: _providers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Primeiro item é o título
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Conheça os estabelecimentos sustentáveis próximos de você",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            );
          }
          // Os outros itens são as lojas (index - 1)
          return _buildProviderCard(_providers[index - 1]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoSteps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _revokeConsent(context),
            tooltip: 'Revogar Consentimento',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      drawer: const ProfileDrawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SustainableGoalListPage()),
          );
        },
        label: const Text('MINHAS METAS'),
        icon: const Icon(Icons.track_changes),
      ),
    );
  }
}
