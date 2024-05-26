import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:yanapa/presentation/gpt/support_gpt_controller.dart';
import 'package:yanapa/presentation/home/controller_home.dart';

class AssistentGpt extends StatefulWidget {
  AssistentGpt({super.key});

  @override
  State<AssistentGpt> createState() => _SupportGptScreenState();
}

class _SupportGptScreenState extends State<AssistentGpt> {
  TextEditingController controllerSearch = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  bool isFocused = false;
  String textSearching = '';

  SupportGptController gptController = Get.find();
  ControllerHome controllerHome = Get.find();

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('YanapaBot'),
      ),
      backgroundColor: Color.fromRGBO(242, 242, 249, 1),
      body: Obx(() => Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: gptController.scrollController,
                        children: [
                          if (controllerHome.listOfImages.length > 0)
                            Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.blueGrey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tus Imagenes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: controllerHome.listOfImages
                                          .map(
                                            (element) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: _imageFileItem(
                                                  File(element.path),
                                                  sizeimage: 50),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          for (final ModelMessageToGpt line
                              in gptController.listMessageToShow)
                            itemMessage(line),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Escribe una pregunta aqui si la tienes...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async {
                              _hideKeyboard();
                              String dataToSend = _controller.text.trim();
                              _controller.clear();
                              await gptController.sendMessage(dataToSend);
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'El asistente potenciado con inteligencia artificial no tiene la palabra final, se recomienda siempre contactar con un especialista',
                        style: TextStyle(fontSize: 10),
                      ),
                    )
                  ],
                ),
                gptController.alertMessage.value
              ],
            ),
          )),
    );
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Widget itemMessage(ModelMessageToGpt line) {
    if (line.rol == 'gpt') {
      return Container(
        // height: constraints.maxHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: CustomColors.greyGreenSimple,
            color: Colors.grey[200],
            border: Border.all(color: Colors.black12)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 60, left: 20, top: 10, bottom: 10),
        child: Markdown(
          data: line.message,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      );
    }
    if (line.rol == 'user') {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: CustomColors.greyGreenSimple,
            color: Colors.blue[100],
            border: Border.all(color: Colors.black12)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 20, left: 60, top: 10, bottom: 10),
        child: Markdown(
          data: line.message,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        // color: CustomColors.greyGreenSimple,
        color: Colors.blueGrey,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Markdown(
        data: line.message,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _imageFileItem(File element, {double sizeimage = 150}) {
    return Container(
      width: sizeimage,
      height: sizeimage,
      decoration: BoxDecoration(
          color: Colors.white60, borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: Get.context!,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.blueGrey[900],
                  // iconPadding: EdgeInsets.all(0),
                  // insetPadding: EdgeInsets.all(0),
                  // titlePadding: EdgeInsets.all(0),
                  // buttonPadding: EdgeInsets.all(0),
                  // actionsPadding: EdgeInsets.all(0),
                  // contentPadding: EdgeInsets.all(0),
                  content: Container(
                    width: MediaQuery.of(Get.context!).size.width,
                    height: MediaQuery.of(Get.context!).size.height,
                    child: Stack(
                      children: [
                        Image.file(
                          element,
                          width: MediaQuery.of(Get.context!).size.width,
                          height: MediaQuery.of(Get.context!).size.height,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blue,
                              ),
                              child: Icon(Icons.arrow_back),
                              padding: EdgeInsets.all(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.file(
                File(element.path),
                width: sizeimage,
                height: sizeimage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget suggestWidget(String suggest, {Function? ontap}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     child: InkWell(
  //       onTap: () {
  //         gptController.sendMessage(suggest);
  //         ontap?.call();
  //       },
  //       child: Ink(
  //         decoration: BoxDecoration(
  //           color: Colors.blue,
  //           borderRadius: BorderRadius.circular(5),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             suggest,
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
