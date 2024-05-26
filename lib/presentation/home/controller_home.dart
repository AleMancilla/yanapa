import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:yanapa/core/utils/utils.dart';
import 'package:yanapa/presentation/gpt/assistent_gpt.dart';
import 'package:yanapa/presentation/gpt/support_gpt_controller.dart';

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

  Future analizeButton() async {
    excecuteProcess(Get.context!, () async {
      List<Map<String, String>> listOfJsonsTextToAnalize =
          await getJsonOfTextSinceImages();

      SupportGptController gptController = Get.put(SupportGptController());
      gptController.isFraud = false;
      await gptController.initChat(listOfJsonsTextToAnalize).then((value) =>
          Navigator.push(Get.context!,
              MaterialPageRoute(builder: (context) => AssistentGpt())));

      print(listOfJsonsTextToAnalize);
    });
  }

  Future<List<Map<String, String>>> getJsonOfTextSinceImages() async {
    List<Map<String, String>> listOfJsons = [];
    for (var xfile in listOfImages) {
      // listOfImages.forEach((xfile) async {
      print(' ------------------------- ');
      final inputImage = InputImage.fromFile(File(xfile.path));
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // String text = recognizedText.text;
      Map<String, String> tempJson = {};
      int i = 0;
      for (TextBlock block in recognizedText.blocks) {
        i = i + 1;
        tempJson["block_$i"] = (block.text.replaceAll('\n', ' ')).trim();
        print(' --- ${block.text.trim()}');
      }
      listOfJsons.add(tempJson);
    }

    dev.log(jsonEncode(listOfJsons));
    print(listOfJsons);
    return listOfJsons;
  }
}
