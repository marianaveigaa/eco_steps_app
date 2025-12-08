import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/prefs_service.dart';
import 'home_screen.dart';

class PolicyViewerScreen extends StatefulWidget {
  const PolicyViewerScreen({super.key});

  @override
  State<PolicyViewerScreen> createState() => _PolicyViewerScreenState();
}

class _PolicyViewerScreenState extends State<PolicyViewerScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  bool _privacyRead = false;
  bool _termsRead = false;
  bool _accepted = false;

  String _privacyText = '';
  String _termsText = '';

  @override
  void initState() {
    super.initState();
    _loadPolicies();
    _scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPolicies() async {
    // Carrega os arquivos MD dos assets
    try {
      _privacyText = await rootBundle.loadString('assets/policies/privacy.md');
      _termsText = await rootBundle.loadString('assets/policies/terms.md');
    } catch (e) {
      debugPrint('Erro ao carregar políticas: $e');
      _privacyText = 'Erro ao carregar Política de Privacidade.';
      _termsText = 'Erro ao carregar Termos de Uso.';
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (mounted) {
        setState(() {
          // Evita divisão por zero se o texto for curto e não tiver scroll
          _scrollProgress = maxScroll > 0 ? currentScroll / maxScroll : 1.0;
        });
      }
    }
  }

  void _markAsRead() {
    if (mounted) {
      setState(() {
        _privacyRead = true;
        _termsRead = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Obrigado por ler! Agora você pode aceitar.')),
      );
    }
  }

  void _accept() async {
    await PrefsService.acceptPolicies('v1');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Políticas e Consentimento')),
      body: Column(
        children: [
          // Barra de progresso de leitura no topo
          LinearProgressIndicator(
            value: _scrollProgress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                // CORREÇÃO: Força o texto a ocupar a largura e alinhar à esquerda
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_privacyText.isNotEmpty) MarkdownBody(data: _privacyText),
                  const Divider(
                      height: 40, thickness: 2), // Divisória mais visível
                  if (_termsText.isNotEmpty) MarkdownBody(data: _termsText),
                  const SizedBox(height: 40),

                  // Botão centralizado no final do texto
                  Center(
                    child: ElevatedButton.icon(
                      // Usa 0.99 para evitar erros de arredondamento no scroll
                      onPressed: _scrollProgress >= 0.99 ? _markAsRead : null,
                      icon: const Icon(Icons.check),
                      label: const Text('Li e Aceito os Termos'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Área fixa no rodapé para o aceite final
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                )
              ],
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text(
                      'Declaro que li e concordo com a Política de Privacidade e os Termos de Uso.'),
                  value: _accepted,
                  // Só libera o checkbox se tiver clicado em "Li e Aceito"
                  onChanged: (_privacyRead && _termsRead)
                      ? (value) {
                          if (mounted) {
                            setState(() => _accepted = value ?? false);
                          }
                        }
                      : null,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (_accepted && _privacyRead && _termsRead)
                        ? _accept
                        : null,
                    child: const Text('Concordo e Continuar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
