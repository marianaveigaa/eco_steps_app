import 'package:flutter/material.dart';
import 'dart:io';
import '../services/prefs_service.dart';
import 'photo_selection_bottom_sheet.dart';
import '../theme/theme_controller.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  late String _displayName;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    setState(() {
      _displayName = PrefsService.userName;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = MediaQuery.of(context).platformBrightness;
    final savedMode = PrefsService.getThemeMode();
    if (savedMode == 'system') {
      _isDark = brightness == Brightness.dark;
    } else {
      _isDark = savedMode == 'dark';
    }
  }

  void _showNameEditDialog() {
    final controller = TextEditingController(text: _displayName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Nome"),
        scrollable: true, // <--- CORREÇÃO 1: Permite rolar se o teclado cobrir
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Seu nome"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                PrefsService.userName = controller.text;
                setState(() {
                  _displayName = controller.text;
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => PhotoSelectionBottomSheet(
        onPhotoChanged: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoPath = PrefsService.userPhotoPath;
    final hasPhoto = photoPath != null && photoPath.isNotEmpty;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: () => _showPhotoOptions(context),
                      child: CircleAvatar(
                        radius:
                            40, // <--- CORREÇÃO 2: Reduzi levemente (de 45 para 40) para não estourar
                        backgroundImage:
                            hasPhoto ? FileImage(File(photoPath)) : null,
                        backgroundColor: !hasPhoto
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        child: !hasPhoto
                            ? const Icon(Icons.person,
                                size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showPhotoOptions(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 20, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Reduzi um pouco o espaçamento
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: _showNameEditDialog,
                      tooltip: "Alterar nome",
                    )
                  ],
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text('Tema Escuro'),
            secondary: Icon(_isDark ? Icons.dark_mode : Icons.light_mode),
            value: _isDark,
            onChanged: (val) {
              setState(() => _isDark = val);
              ThemeController.instance.toggleTheme(val);
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Sua foto e dados ficam apenas neste dispositivo'),
          ),
        ],
      ),
    );
  }
}
