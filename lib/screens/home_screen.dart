import 'package:flutter/material.dart';
// Imports corrigidos para usar o caminho do pacote
import 'package:ecosteps/services/prefs_service.dart';
import 'package:ecosteps/services/supabase_repository.dart';
import 'package:ecosteps/services/local_cache_service.dart';
import 'package:ecosteps/domain/entities/eco_provider.dart';
import 'package:ecosteps/widgets/profile_drawer.dart';
import 'package:ecosteps/screens/splash_screen.dart';

// --- ESTA É A IMPORTAÇÃO QUE FALTAVA ---
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

  // Método separado para construir cards
  Widget _buildProviderCard(EcoProvider provider) {
    final distanceText =
        provider.distanceKm != null ? '${provider.distanceKm} km' : 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: provider.imageUrl != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(provider.imageUrl!),
              )
            : const CircleAvatar(
                child: Icon(Icons.eco),
              ),
        title: Text(provider.name),
        subtitle: Text('⭐ ${provider.rating} • $distanceText'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showComingSoon(context),
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

                    // ===========================================
                    // AQUI ESTÁ A CORREÇÃO (NO LUGAR CERTO)
                    // ===========================================
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

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        itemCount: _providers.length,
        itemBuilder: (context, index) {
          return _buildProviderCard(_providers[index]);
        },
      ),
    );
  }
}
