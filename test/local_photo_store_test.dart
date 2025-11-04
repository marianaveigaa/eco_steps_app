import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecosteps/services/local_photo_store.dart';

void main() {
  test('Salvar foto comprime e salva arquivo', () async {
    final testFile = File('test/test_image.jpg');
    expect(testFile.existsSync(), true,
        reason: 'Arquivo de teste deve existir');

    final savedPath = await LocalPhotoStore.savePhoto(testFile);
    expect(savedPath, isNotNull);
    expect(savedPath.contains('user_photo'), true);

    final savedFile = await LocalPhotoStore.getPhoto(savedPath);
    expect(savedFile, isNotNull);
    expect(savedFile!.lengthSync(), lessThan(200 * 1024),
        reason: 'Arquivo deve ser ≤200KB após compressão');
  });
}
