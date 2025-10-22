import 'package:flutter/material.dart';
import 'dart:io';
import '../services/prefs_service.dart';
import 'photo_selection_bottom_sheet.dart';

class ProfileDrawer extends StatefulWidget {
  // Mudei para Stateful
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    final photoPath = PrefsService.userPhotoPath;
    final hasPhoto = photoPath != null && photoPath.isNotEmpty;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: GestureDetector(
              onTap: () => _showPhotoOptions(context),
              child: Semantics(
                label: 'Avatar do usuário. Toque para editar foto.',
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: hasPhoto ? FileImage(File(photoPath)) : null,
                  child: !hasPhoto
                      ? const Text('U', style: TextStyle(fontSize: 40))
                      : null,
                ),
              ),
            ),
          ),
          const ListTile(
              title: Text(
                  'Mensagem: Sua foto fica neste dispositivo, você pode remover quando quiser.')),
        ],
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => PhotoSelectionBottomSheet(
        onPhotoChanged: () =>
            setState(() {}), // Adicione callback para recarregar
      ),
    );
  }
}
