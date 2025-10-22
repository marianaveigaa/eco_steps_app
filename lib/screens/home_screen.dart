import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import '../widgets/profile_drawer.dart'; // Para Drawer
import 'splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _revokeConsent(BuildContext context) {
    print('Tentando revogar consentimento'); // Log
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Revogar Consentimento'),
        content: const Text(
            'Tem certeza? Isso resetará seu progresso e levará você de volta ao onboarding.'),
        actions: [
          TextButton(
            onPressed: () {
              print('Cancelado'); // Log
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              print('Revogando...'); // Log
              await PrefsService.revokeAcceptance();
              Navigator.pop(context); // Fecha dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      'Consentimento revogado. Você será redirecionado.'),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () async {
                      await PrefsService.acceptPolicies('v1');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Consentimento restaurado!')),
                      );
                    },
                  ),
                ),
              );
              Future.delayed(const Duration(seconds: 3), () {
                print('Redirecionando para Splash'); // Log
                Navigator.pushReplacement(
                  // Mudei para pushReplacement se pushAndRemoveUntil falhar
                  context,
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                );
              });
            },
            child: const Text('Revogar'),
          ),
        ],
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
        ],
      ),
      drawer: const ProfileDrawer(), // Adicione se não tiver
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.eco, size: 100, color: Color(0xFF16A34A)),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo ao EcoSteps!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Crie sua primeira meta sustentável da semana!',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Funcionalidade em breve!')),
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
        ),
      ),
    );
  }
}
