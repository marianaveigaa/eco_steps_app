import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecosteps/core/services/prefs_service.dart';
import 'package:ecosteps/core/services/service_locator.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _revokeConsent(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revogar Consentimento?'),
        content: const Text(
          'Você precisará aceitar os termos novamente para usar o app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final prefsService = getIt<PrefsService>();
      final originalVersion = prefsService.getAcceptedPoliciesVersion() ?? 'v1';

      await prefsService.revokeAcceptance();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: const Text('Consentimento revogado.'),
              action: SnackBarAction(
                label: 'DESFAZER',
                onPressed: () async {
                  await prefsService.acceptPolicies(originalVersion);
                },
              ),
            ),
          )
          .closed
          .then((reason) {
            // Se o SnackBar fechou sem a ação de "Desfazer"
            if (reason != SnackBarClosedReason.action && context.mounted) {
              // Navega para o início do fluxo, limpando as telas anteriores
              context.go('/onboarding');
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Rever Política de Privacidade'),
            onTap: () => context.push(
              '/policy-viewer',
              extra: 'assets/markdown/privacy_policy_v1.md',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('Rever Termos de Uso'),
            onTap: () => context.push(
              '/policy-viewer',
              extra: 'assets/markdown/terms_of_use_v1.md',
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.gpp_bad_outlined, color: Colors.red.shade700),
            title: Text(
              'Revogar Consentimento',
              style: TextStyle(color: Colors.red.shade700),
            ),
            onTap: () => _revokeConsent(context),
          ),
        ],
      ),
    );
  }
}
