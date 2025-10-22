import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
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
    final hasPhoto = PrefsService.userPhotoPath != null &&
        PrefsService.userPhotoPath!.isNotEmpty;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Selecionar da Galeria'),
            onTap: isDesktop
                ? () => _pickFileDesktop(context)
                : () => _showMobileMessage(context),
          ),
          if (hasPhoto)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remover Foto',
                  style: TextStyle(color: Colors.red)),
              onTap: () => _removePhoto(context),
            ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Cancelar'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showMobileMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Use dispositivo mobile para câmera/galeria.'),
        duration: Duration(seconds: 2),
      ),
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
        // Converter XFile para File
        final imageFile = File(file.path);

        // Verificar se arquivo existe
        if (await imageFile.exists()) {
          final savedPath = await LocalPhotoStore.savePhoto(imageFile);
          PrefsService.userPhotoPath = savedPath;
          PrefsService.userPhotoUpdatedAt = DateTime.now();

          if (context.mounted) {
            Navigator.pop(context);
            onPhotoChanged?.call();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Foto de perfil atualizada!')),
            );
          }
        } else {
          throw Exception('Arquivo não encontrado');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  Future<void> _removePhoto(BuildContext context) async {
    try {
      final path = PrefsService.userPhotoPath;
      if (path != null && path.isNotEmpty) {
        await LocalPhotoStore.deletePhoto(path);
        await PrefsService.clearPhotoData();

        if (context.mounted) {
          Navigator.pop(context);
          onPhotoChanged?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto removida!')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover: $e')),
        );
      }
    }
  }
}
