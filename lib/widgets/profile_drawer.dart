import 'package:flutter/material.dart';
import 'dart:io';
import '../services/prefs_service.dart';
import 'photo_selection_bottom_sheet.dart';

class ProfileDrawer extends StatefulWidget {
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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _showPhotoOptions(context),
                  child: CircleAvatar(
                    radius: 40,
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
                const SizedBox(height: 10),
                const Text('Usuário'),
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Sua foto fica apenas neste dispositivo'),
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
}
