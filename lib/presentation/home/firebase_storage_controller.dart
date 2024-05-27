import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as Img;
// import 'package:path/path.dart' as Path;

class FirebaseStorageController {
  Future<String?> uploadImage(File? image) async {
    if (image != null) {
      // Comprimir la imagen antes de subirla
      File compressedImageFile = await compressImage(image);

      // Subir el archivo comprimido a Firebase Storage
      // String fileName = Path.basename(compressedImageFile.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/${DateTime.now()}');
      UploadTask uploadTask = storageReference.putFile(
          compressedImageFile,
          SettableMetadata(
            contentType: 'image/jpeg',
          ));
      await uploadTask.whenComplete(() => print('Image uploaded'));

      // Obtener la URL de descarga de la imagen
      String downloadURL = await storageReference.getDownloadURL();
      print('Download URL: $downloadURL');
      return downloadURL;
    } else {
      // showToastMessage("no se encontro la imagen");
      return null;
    }
  }

  Future<File> compressImage(File imageFile) async {
    // Decodificar la imagen utilizando la biblioteca image
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync())!;

    // Redimensionar la imagen a un tamaño específico (opcional)
    image = Img.copyResize(image, width: 800);

    // Crear un archivo temporal para la imagen comprimida
    File compressedImageFile = File('${imageFile.path}.compressed.jpg');

    // Codificar la imagen en formato JPEG con una calidad del 80% y guardarla en el archivo temporal
    compressedImageFile.writeAsBytesSync(Img.encodeJpg(image, quality: 80));

    return compressedImageFile;
  }
}
