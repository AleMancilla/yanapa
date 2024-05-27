import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:yanapa/core/utils/utils.dart';
import 'package:yanapa/presentation/gpt/assistent_gpt.dart';
import 'package:yanapa/presentation/gpt/support_gpt_controller.dart';
import 'package:yanapa/presentation/home/firebase_firestore.dart';
import 'package:yanapa/presentation/home/firebase_storage_controller.dart';

class HomeController extends GetxController {
  final picker = ImagePicker();
  SupportGptController gptController = Get.put(SupportGptController());

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
    excecuteProcess(Get.context!, () async {
      List<Map<String, String>> listOfJsonsTextToAnalize =
          await gptController.getJsonOfTextSinceImages();
      gptController.isFraud = false;
      await gptController.initChat(listOfJsonsTextToAnalize).then((value) =>
          Navigator.push(Get.context!,
              MaterialPageRoute(builder: (context) => AssistentGpt())));

      print(listOfJsonsTextToAnalize);
    });
  }
}
