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

  Future<void> _loadPolicies() async {
    _privacyText = await rootBundle.loadString('assets/policies/privacy.md');
    _termsText = await rootBundle.loadString('assets/policies/terms.md');
    setState(() {});
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _scrollProgress = maxScroll > 0 ? currentScroll / maxScroll : 1.0;
      });
    }
  }

  void _markAsRead() {
    setState(() {
      _privacyRead = true;
      _termsRead = true;
    });
  }

  void _accept() async {
    await PrefsService.acceptPolicies('v1');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Políticas e Consentimento')),
      body: Column(
        children: [
          LinearProgressIndicator(value: _scrollProgress),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  MarkdownBody(data: _privacyText),
                  const Divider(),
                  MarkdownBody(data: _termsText),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _scrollProgress >= 1.0 ? _markAsRead : null,
                    child: const Text('Marcar como Lido'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text(
                      'Aceito as políticas de privacidade e termos.'),
                  value: _accepted,
                  onChanged: (_privacyRead && _termsRead)
                      ? (value) => setState(() => _accepted = value ?? false)
                      : null,
                ),
                ElevatedButton(
                  onPressed: (_accepted && _privacyRead && _termsRead)
                      ? _accept
                      : null,
                  child: const Text('Concordo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
