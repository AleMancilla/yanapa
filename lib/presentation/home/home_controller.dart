import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:yanapa/core/utils/geolocation_controller.dart';
import 'package:yanapa/core/utils/user_preferens.dart';
import 'package:yanapa/core/utils/utils.dart';
import 'package:yanapa/presentation/gpt/assistent_gpt.dart';
import 'package:yanapa/presentation/gpt/support_gpt_controller.dart';

class HomeController extends GetxController {
  final picker = ImagePicker();
  SupportGptController gptController = Get.put(SupportGptController());

  GeolocationController geolocationController =
      Get.put(GeolocationController());
  addListOfFile() async {
    List<XFile> tempList = await getListOfImagesFromGalery();
    gptController.listOfImages.value = [
      ...gptController.listOfImages,
      ...tempList
    ];
  }

  removeFileFromList(File file) {
    XFile? xfileToRemove;
    gptController.listOfImages.forEach((element) {
      if (file.path == element.path) {
        xfileToRemove = element;
      }
    });
    if (xfileToRemove != null) {
      gptController.listOfImages.remove(xfileToRemove);
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

  Future analizeButton() async {
    // FirebaseStorageController().
    if (!(UserPreferences().userPermisionGeolocation ?? false)) {
      await showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: Text('Permisos de Ubicación'),
            content: Text(
                'Solicitamos permisos de Ubicación para recopilar informacion de donde pueden operar los posibles estafadores digitales'
                'Esto nos permitirá mejorar los servicios y alertar a otras personas que no caigan en estas estafas'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Continuar sin permitir',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  UserPreferences().userPermisionGeolocation = true;
                  await geolocationController.chargePositioned();
                },
                child: Text('Permitir'),
              ),
            ],
          );
        },
      );
    } else {
      excecuteProcess(Get.context!, () async {
        await geolocationController.chargePositioned();
      });
    }
    excecuteProcess(Get.context!, () async {
      // List<Map<String, String>> listOfJsonsTextToAnalize =
      await gptController.chargeTextInListData();
      gptController.isFraud = false;
      await gptController.initChat().then((value) => Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => AssistentGpt())));
    });
  }
}
