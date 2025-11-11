import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecosteps/domain/entities/sustainable_category.dart';
import 'package:ecosteps/domain/entities/sustainable_goal.dart';
import 'package:ecosteps/domain/repositories/i_sustainable_goal_repository.dart';

Future<SustainableGoal?> showSustainableGoalFormDialog(
  BuildContext context, {
  SustainableGoal? initial,
  required ISustainableGoalRepository repository, // Recebe o repositório
}) {
  return showDialog<SustainableGoal>(
    context: context,
    builder: (ctx) => _SustainableGoalFormDialog(
      initial: initial,
      repository: repository, // Passa para o widget
    ),
  );
}

class _SustainableGoalFormDialog extends StatefulWidget {
  final SustainableGoal? initial;
  final ISustainableGoalRepository repository;

  const _SustainableGoalFormDialog({
    this.initial,
    required this.repository,
  });

  @override
  State<_SustainableGoalFormDialog> createState() =>
      _SustainableGoalFormDialogState();
}

class _SustainableGoalFormDialogState
    extends State<_SustainableGoalFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _targetValueController;
  late final TextEditingController _currentValueController;
  late final TextEditingController _unitController;

  SustainableCategory? _selectedCategory;
  DateTime? _selectedDate;
  bool _isCompleted = false;
  bool _isLoading = false;

  bool get isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _descriptionController =
        TextEditingController(text: initial?.description ?? '');
    _targetValueController =
        TextEditingController(text: initial?.targetValue.toString() ?? '');
    _currentValueController =
        TextEditingController(text: initial?.currentValue.toString() ?? '0');
    _unitController = TextEditingController(text: initial?.unit ?? '');

    _selectedCategory = SustainableCategory.values.firstWhere(
      (e) => e.name == initial?.category,
      orElse: () => SustainableCategory.lixo,
    );
    _selectedDate = initial?.deadline ?? DateTime.now();
    _isCompleted = initial?.completed ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetValueController.dispose();
    _currentValueController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return date.toIso8601String();
    }
  }

  Future<void> _onConfirm() async {
    if (_titleController.text.trim().isEmpty) {
      _showError('Título é obrigatório.');
      return;
    }
    if (_targetValueController.text.trim().isEmpty) {
      _showError('Valor alvo é obrigatório.');
      return;
    }
    final targetValue = double.tryParse(_targetValueController.text.trim());
    if (targetValue == null || targetValue <= 0) {
      _showError('Valor alvo deve ser um número maior que 0.');
      return;
    }
    final currentValue =
        double.tryParse(_currentValueController.text.trim()) ?? 0.0;
    if (currentValue < 0) {
      _showError('Valor atual deve ser >= 0.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final date = _selectedDate ?? DateTime.now();
    final now = DateTime.now();

    final goal = SustainableGoal(
      // Se for edição, usa o ID existente.
      // Se for criação, mandamos 0 e o Supabase (com a config certa)
      // vai criar um novo ID.
      id: widget.initial?.id ?? 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory?.name ?? 'lixo',
      targetValue: targetValue,
      currentValue: currentValue,
      unit: _unitController.text.trim(),
      deadline: date,
      completed: _isCompleted,
      updatedAt: now,
    );

    try {
      await widget.repository.saveGoal(goal);

      if (mounted) {
        Navigator.of(context).pop(goal);
      }
    } catch (e) {
      _showError('Erro ao salvar: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar Meta' : 'Adicionar Meta'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 8),
                    InputDecorator(
                      decoration:
                          const InputDecoration(labelText: 'Tipo de meta'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<SustainableCategory>(
                          value: _selectedCategory,
                          isExpanded: true,
                          items: SustainableCategory.values
                              .map((g) => DropdownMenuItem(
                                    value: g,
                                    child: Row(
                                      children: [
                                        Icon(g.icon, size: 20),
                                        const SizedBox(width: 8),
                                        Text(g.description),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _targetValueController,
                            decoration:
                                const InputDecoration(labelText: 'Valor Alvo'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _unitController,
                            decoration: const InputDecoration(
                                labelText: 'Unidade (ex: kg, L)'),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _currentValueController,
                      decoration:
                          const InputDecoration(labelText: 'Valor Atual'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration:
                                const InputDecoration(labelText: 'Prazo'),
                            child: Text(_formatDate(_selectedDate!)),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickDate,
                          child: const Text('Escolher'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(child: Text('Concluída?')),
                        Switch(
                          value: _isCompleted,
                          onChanged: (v) => setState(() => _isCompleted = v),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(null),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _onConfirm,
          child: Text(isEditing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }
}
