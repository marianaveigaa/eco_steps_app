import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_selector/file_selector.dart'; // Novo
import 'package:flutter/foundation.dart';
import '../services/prefs_service.dart';
import '../services/local_photo_store.dart';

class PhotoSelectionBottomSheet extends StatelessWidget {
  final VoidCallback? onPhotoChanged;

  const PhotoSelectionBottomSheet({super.key, this.onPhotoChanged});

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.photo),
          title: const Text('Selecionar Foto'),
          onTap: isDesktop
              ? () => _pickFileDesktop(context)
              : () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Use dispositivo mobile para câmera/galeria.'))),
        ),
        if (PrefsService.userPhotoPath != null)
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Remover Foto'),
            onTap: () => _removePhoto(context),
          ),
      ],
    );
  }

  Future<void> _pickFileDesktop(BuildContext context) async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'Imagens',
        extensions: ['jpg', 'png', 'jpeg'],
      );
      final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file != null) {
        final savedPath = await LocalPhotoStore.savePhoto(File(file.path));
        PrefsService.userPhotoPath = savedPath;
        PrefsService.userPhotoUpdatedAt = DateTime.now();
        Navigator.pop(context);
        onPhotoChanged?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto adicionada do desktop!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  Future<void> _removePhoto(BuildContext context) async {
    try {
      final path = PrefsService.userPhotoPath;
      if (path != null) {
        await LocalPhotoStore.deletePhoto(path);
        await PrefsService.clearPhotoData();
        Navigator.pop(context);
        onPhotoChanged?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto removida!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover: $e')),
      );
    }
  }
}
