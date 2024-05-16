import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:yanapa/presentation/home/controller_home.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  ControllerHome controllerHome = Get.put(ControllerHome());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                        onTap: () {},
                        child: Ink(
                          // margin: EdgeInsets.all(20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            'Tutorial. 🧐',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _btnChargeImageHere(size),
                SizedBox(height: 20),
                if (controllerHome.listOfImages.length > 0)
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: controllerHome.listOfImages
                        .map(
                          (element) => _imageFileItem(File(element.path)),
                        )
                        .toList(),
                  ),
                SizedBox(height: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    controllerHome.analizeButton();
                  },
                  child: Ink(
                    child: Text(
                      'Analizar',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                          )
                        ]),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _imageFileItem(File element) {
    return Container(
      width: 150,
      height: 150,
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
                width: 150,
                height: 150,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controllerHome.removeFileFromList(element);
                },
                child: Ink(
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Icon(
                    Icons.close,
                    size: 15,
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _btnChargeImageHere(Size size) {
    bool _listEmpty = controllerHome.listOfImages.length == 0;
    if (_listEmpty) {
      return InkWell(
        onTap: () {
          controllerHome.addListOfFile();
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/images/undraw_add_files_re_v09g.svg',
                  width: size.width - 150,
                ),
                // child: Image.asset(
                //   'assets/images/undraw_Add_files_re_v09g.png',
                //   width: size.width - 100,
                // ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  'Carga las imagenes aqui',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          controllerHome.addListOfFile();
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/images/undraw_add_files_re_v09g.svg',
                  width: 100,
                ),
                // child: Image.asset(
                //   'assets/images/undraw_Add_files_re_v09g.png',
                //   width: size.width - 100,
                // ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    'Carga las imagenes aqui',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
