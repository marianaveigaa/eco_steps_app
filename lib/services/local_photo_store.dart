import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class LocalPhotoStore {
  static Future<String> savePhoto(File photoFile) async {
    // Obter diretório de documentos
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'user_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${dir.path}/$fileName';

    try {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        photoFile.path,
        filePath,
        quality: 80,
      );

      if (compressedFile != null) {
        return compressedFile.path;
      } else {
        final copiedFile = await photoFile.copy(filePath);
        return copiedFile.path;
      }
    } catch (e) {
      final copiedFile = await photoFile.copy(filePath);
      return copiedFile.path;
    }
  }

  static Future<File?> getPhoto(String path) async {
    final file = File(path);
    return await file.exists() ? file : null;
  }

  static Future<void> deletePhoto(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignorar erro na deleção
    }
  }
}
