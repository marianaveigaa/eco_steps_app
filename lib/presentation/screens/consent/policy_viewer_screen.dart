// lib/presentation/screens/consent/policy_viewer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';

class PolicyViewerScreen extends StatefulWidget {
  final String markdownFile;
  const PolicyViewerScreen({super.key, required this.markdownFile});

  @override
  State<PolicyViewerScreen> createState() => _PolicyViewerScreenState();
}

class _PolicyViewerScreenState extends State<PolicyViewerScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledToEnd = false;
  double _scrollProgress = 0.0;
  String _markdownData = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
    _scrollController.addListener(_updateScrollProgress);
  }

  void _loadMarkdown() async {
    try {
      final data = await rootBundle.loadString(widget.markdownFile);
      if (mounted) {
        setState(() {
          _markdownData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _markdownData = '## Erro ao carregar o documento.';
          _isLoading = false;
        });
      }
    }
  }

  void _updateScrollProgress() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll > 0) {
      setState(() {
        _scrollProgress = currentScroll / maxScroll;
        _isScrolledToEnd = (maxScroll - currentScroll) < 1.0;
      });
    } else {
      setState(() {
        _scrollProgress = 1.0;
        _isScrolledToEnd = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.markdownFile.contains('privacy')
              ? 'Política de Privacidade'
              : 'Termos de Uso',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: _scrollProgress,
            backgroundColor: Colors.white.withAlpha(128),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: MarkdownWidget(data: _markdownData),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed:
              _isScrolledToEnd ? () => Navigator.of(context).pop(true) : null,
          child: const Text('Marcar como Lido'),
        ),
      ),
    );
  }
}
