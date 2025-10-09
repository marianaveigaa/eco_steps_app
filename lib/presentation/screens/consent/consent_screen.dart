import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecosteps/core/services/prefs_service.dart';
import 'package:ecosteps/core/services/service_locator.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _privacyPolicyRead = false;
  bool _termsOfUseRead = false;
  bool _consentChecked = false;

  bool get _canGiveConsent => _privacyPolicyRead && _termsOfUseRead;
  bool get _canProceed => _canGiveConsent && _consentChecked;

  Future<void> _viewPolicy(String markdownFile) async {
    final result = await context.push<bool>(
      '/policy-viewer',
      extra: markdownFile,
    );
    if (result == true) {
      setState(() {
        if (markdownFile.contains('privacy')) {
          _privacyPolicyRead = true;
        } else if (markdownFile.contains('terms')) {
          _termsOfUseRead = true;
        }
      });
    }
  }

  void _onProceed() {
    final prefsService = getIt<PrefsService>();
    prefsService.acceptPolicies('v1');
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consentimento')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Antes de começar...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Para usar o EcoSteps, por favor, leia e aceite nossos documentos legais.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            _buildPolicyTile(
              context,
              title: 'Política de Privacidade',
              read: _privacyPolicyRead,
              onTap: () => _viewPolicy('assets/markdown/privacy_policy_v1.md'),
            ),
            const SizedBox(height: 16),
            _buildPolicyTile(
              context,
              title: 'Termos de Uso',
              read: _termsOfUseRead,
              onTap: () => _viewPolicy('assets/markdown/terms_of_use_v1.md'),
            ),
            const Spacer(),
            CheckboxListTile(
              title: const Text('Eu li e concordo com ambos os documentos.'),
              value: _consentChecked,
              onChanged: _canGiveConsent
                  ? (bool? value) =>
                        setState(() => _consentChecked = value ?? false)
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _canProceed ? _onProceed : null,
              child: const Text('Concordo e Continuar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyTile(
    BuildContext context, {
    required String title,
    required bool read,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Icon(
        read ? Icons.check_circle : Icons.radio_button_unchecked,
        color: read ? Colors.green : Colors.grey,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
