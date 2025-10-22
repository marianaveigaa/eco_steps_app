import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import '../widgets/profile_drawer.dart';
import 'splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

    // Fecha o dialog primeiro
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    // Mostra snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consentimento revogado. Redirecionando...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navega após delay
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
        ],
      ),
      drawer: const ProfileDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco, size: 100, color: Color(0xFF16A34A)),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo ao EcoSteps!',
                style: Theme.of(context).textTheme.headlineSmall,
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
                        onPressed: () => _showComingSoon(context),
                        child: const Text('Criar Meta'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
