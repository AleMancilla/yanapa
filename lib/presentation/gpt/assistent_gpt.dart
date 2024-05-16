import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yanapa/presentation/gpt/support_gpt_controller.dart';
import 'package:yanapa/presentation/home/controller_home.dart';

class AssistentGpt extends StatefulWidget {
  AssistentGpt({super.key});

  @override
  State<AssistentGpt> createState() => _SupportGptScreenState();
}

class _SupportGptScreenState extends State<AssistentGpt> {
  TextEditingController controllerSearch = TextEditingController();

  bool isFocused = false;

  String textSearching = '';

  SupportGptController gptController = Get.find();
  ControllerHome controllerHome = Get.find();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(gptController);

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
                        children: [
                          if (controllerHome.listOfImages.length > 0)
                            Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.blueGrey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
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
                          if (gptController.isFraud)
                            Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.red[300],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Posibles fraudes similares',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        'assets/posibles/1.jpeg',
                                        'assets/posibles/2.jpeg',
                                        'assets/posibles/3.jpeg',
                                        'assets/posibles/4.jpeg',
                                        'assets/posibles/5.jpeg',
                                        'assets/posibles/6.jpg',
                                        'assets/posibles/7.jpeg',
                                        'assets/posibles/8.jpg',
                                        'assets/posibles/9.jpeg',
                                        'assets/posibles/10.jpeg',
                                      ]
                                          .map(
                                            (element) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: Get.context!,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      backgroundColor:
                                                          Colors.blueGrey[900],
                                                      // iconPadding: EdgeInsets.all(0),
                                                      // insetPadding: EdgeInsets.all(0),
                                                      // titlePadding: EdgeInsets.all(0),
                                                      // buttonPadding: EdgeInsets.all(0),
                                                      // actionsPadding: EdgeInsets.all(0),
                                                      contentPadding:
                                                          EdgeInsets.all(0),
                                                      content: Container(
                                                        width: MediaQuery.of(
                                                                Get.context!)
                                                            .size
                                                            .width,
                                                        height: MediaQuery.of(
                                                                Get.context!)
                                                            .size
                                                            .height,
                                                        child: Stack(
                                                          children: [
                                                            Image.asset(
                                                              element,
                                                              width: MediaQuery
                                                                      .of(Get
                                                                          .context!)
                                                                  .size
                                                                  .width,
                                                              height: MediaQuery
                                                                      .of(Get
                                                                          .context!)
                                                                  .size
                                                                  .height,
                                                            ),
                                                            Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Ink(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  child: Icon(Icons
                                                                      .arrow_back),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              15),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Image.asset(
                                                    element,
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
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

                    // if (gptController.listMessageToShow.length > 0)
                    //   SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: [
                    //         suggestWidget(
                    //           'Recomendaciones sobre cuidados',
                    //         ),
                    //         suggestWidget(
                    //           'Mas informacion sobre mi diagnostico',
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // if (gptController.waitingResponse.value) CustomLoadingWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Escribe una pregunta aqui si la tienes...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async {
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

  Widget suggestWidget(String suggest, {Function? ontap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          gptController.sendMessage(suggest);
          ontap?.call();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              suggest,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Container itemMessage(ModelMessageToGpt line) {
    if (line.rol == 'gpt') {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            // color: CustomColors.greyGreenSimple,
            color: Colors.grey[200],
            border: Border.all(color: Colors.black12)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 60, left: 20, top: 10, bottom: 10),
        child: Text(line.message),
      );
    }
    if (line.rol == 'user') {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          // color: CustomColors.greyGreenSimple,
          color: Colors.blueGrey,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 20, left: 60, top: 10, bottom: 10),
        child: Text(line.message),
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
      child: Text(line.message),
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
                  contentPadding: EdgeInsets.all(0),
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
}
