import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:yanapa/presentation/gpt/support_gpt_controller.dart';

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
                // gptController.alertMessage.value
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container()),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                child: Ink(
                                  // margin: EdgeInsets.all(20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Text(
                                    'X',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          margin:
                              EdgeInsets.only(left: 50, right: 50, bottom: 100),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 20),
                                  Flexible(
                                    child: Text(
                                      'ALERTA DE POSIBLE FRAUDE',
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: Text(
                                    'Se detecto una posible alerta de fraude, puedes brindar mas informacion a nuestro ChatBot para mas informacion o denunciar a instancias de la ATT en los botones a continuacion'),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Denuncialo en cualquiera de los siguientes botones',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Ink(
                                      child: Image.asset(
                                          'assets/images/whatsapp.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Ink(
                                      child: Image.asset(
                                          'assets/images/telephone.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Ink(
                                      child: Image.asset(
                                          'assets/images/gmail.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
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
          color: Colors.blueGrey,
        ),
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
}
