import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ControllerHome extends GetxController {
  RxList<XFile> listOfImages = <XFile>[].obs;
  final picker = ImagePicker();

  addListOfFile() async {
    List<XFile> tempList = await getListOfImagesFromGalery();
    listOfImages.value = [...listOfImages, ...tempList];
  }

  removeFileFromList(File file) {
    XFile? xfileToRemove;
    listOfImages.forEach((element) {
      if (file.path == element.path) {
        xfileToRemove = element;
      }
    });
    if (xfileToRemove != null) {
      listOfImages.remove(xfileToRemove);
    }
  }

  Future<File?> getImageFromGalery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    return null;
  }

  Future<List<XFile>> getListOfImagesFromGalery() async {
    final pickedFile = await picker.pickMultiImage();

    if (pickedFile.isNotEmpty) {
      return pickedFile;
      // return File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    return [];
  }
}
