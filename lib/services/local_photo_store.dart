import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class LocalPhotoStore {
  static Future<String> savePhoto(File photoFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'user_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${dir.path}/$fileName';

    // Comprimir e remover EXIF
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      photoFile.path,
      filePath,
      quality: 85, // Ajuste para ≤200KB
      minWidth: 512,
      minHeight: 512,
    );

    if (compressedFile != null) {
      return compressedFile.path;
    } else {
      throw Exception('Falha na compressão da imagem');
    }
  }

  static Future<File?> getPhoto(String path) async {
    final file = File(path);
    return await file.exists() ? file : null;
  }

  static Future<void> deletePhoto(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
